Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbaJ2PmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:42:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097AbaJ2PmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:02 -0400
Date: Wed, 29 Oct 2014 16:47:02 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] staging - rtl8188eu: Deletion of unnecessary checks
 before three function calls
Message-ID: <20141029084702.GA18675@kroah.com>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <544954FD.8040607@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544954FD.8040607@users.sourceforge.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 09:20:29PM +0200, SF Markus Elfring wrote:
> >From 45970693cad6c12da2d5ac7da3d2bd7a566170d7 Mon Sep 17 00:00:00 2001
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 23 Oct 2014 20:55:13 +0200
> Subject: [PATCH] staging - rtl8188eu: Deletion of unnecessary checks before
>  three function calls

Why is this here?  Please use git send-email to send a patch, so I don't
have to hand-edit the text in it.

Also, your Subject is a bit odd, it has a "Re:" in it for no reason, and
your From: doesn't match the name you used here.

Please fix up and resend.

thanks,

greg k-h
