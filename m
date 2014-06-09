Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbaFIW1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:27:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaFIW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:27:10 -0400
Date: Mon, 9 Jun 2014 15:30:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: torvalds@linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds
 checking
Message-ID: <20140609223057.GB18475@kroah.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401332999-15167-1-git-send-email-eparis@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 11:09:58PM -0400, Eric Paris wrote:
> From: Andy Lutomirski <luto@amacapital.net>
> 
> Fixes an easy DoS and possible information disclosure.
> 
> This does nothing about the broken state of x32 auditing.
> 
> eparis: If the admin has enabled auditd and has specifically loaded audit
> rules.  This bug has been around since before git.  Wow...
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
>  kernel/auditsc.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)

Did this patch get dropped somewhere?  Isn't it a valid bugfix, or did I
miss a later conversation about this?

thanks,

greg k-h
