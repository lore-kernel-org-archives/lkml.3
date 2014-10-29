Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbaJ2PwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:52:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbaJ2PwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:52:05 -0400
Date: Wed, 29 Oct 2014 23:50:55 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: stable@vger.kernel.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, sgrubb@redhat.com, pmoore@redhat.com
Subject: Re: [PATCH][STABLE] audit: correct AUDIT_GET_FEATURE return message
 type
Message-ID: <20141029155055.GC17232@kroah.com>
References: <20141029133506.GN26201@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029133506.GN26201@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 09:35:06AM -0400, Richard Guy Briggs wrote:
> When an AUDIT_GET_FEATURE message is sent from userspace to the kernel, it
> should reply with a message tagged as an AUDIT_GET_FEATURE type with a struct
> audit_feature.  The current reply is a message tagged as an AUDIT_GET
> type with a struct audit_feature.
> 
> This appears to have been a cut-and-paste-eo in commit b0fed40.
> 
> Reported-by: Steve Grubb <sgrubb@redhat.com>
> Cc: stable@vger.kernel.org # v3.13-rc1
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Why did you send this directly to stable@vger?  That's not how to get a
patch into the stable kernel trees...
