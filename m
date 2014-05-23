Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaEWW0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:26:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaEWW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:26:07 -0400
Date: Sat, 24 May 2014 07:26:05 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: chad@dahc.us, michael.banken@mathe.stud.uni-erlangen.de,
        lorenz@badgers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c: Fixed a lot of
 checkpatch.pl warnings
Message-ID: <20140523222605.GA8839@kroah.com>
References: <1400881630-23997-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400881630-23997-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 02:47:10PM -0700, Chaitanya Hazarey wrote:
> Added a blank line after declarations in many places to fix the following warning issued by checkpatch.pl:
> 
> WARNING: Missing a blank line after declarations
> ---
>  drivers/staging/silicom/bpctl_mod.c |   90 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 88 insertions(+), 2 deletions(-)

Something is corrupted in this patch and it doesn't apply properly.  Can
you resend it to yourself and try to figure out what went wrong?

thanks,

greg k-h
