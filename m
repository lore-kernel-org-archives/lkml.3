Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaEZAvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 20:51:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaEZAvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 20:51:52 -0400
Date: Sun, 25 May 2014 17:51:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: chad@dahc.us, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Adding blank
 lines
Message-ID: <20140526005151.GB3129@kroah.com>
References: <1401064618-29405-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401064618-29405-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 05:36:58PM -0700, Chaitanya Hazarey wrote:
> Added a blank line after declarations in many places to fix the following warning issued by checkpatch.pl:

Always wrap your lines at 72 columns, like git asks you to when you type
in the commit message.

> WARNING: Missing a blank line after declarations
> 
> The reason why it was not applying clean against Greg's tree was that bpctl_mod.c had changed in the functions which are a part of this patch. 

This doesn't belong as part of the changelog, right?  Please resend and
put it below the --- line, if you want to.

Can you redo this with the changelog fixed up please?

thanks,

greg k-h
