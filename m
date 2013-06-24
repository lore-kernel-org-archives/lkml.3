Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3FXXLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:11:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3FXXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:11:06 -0400
Date: Mon, 24 Jun 2013 16:11:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chad Williamson <chad@dahc.us>
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] Staging: silicom: remove the bpctl_dev_t typdef
Message-ID: <20130624231105.GA6676@kroah.com>
References: <1371970948-26802-1-git-send-email-chad@dahc.us>
 <1371970948-26802-4-git-send-email-chad@dahc.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371970948-26802-4-git-send-email-chad@dahc.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 02:02:25AM -0500, Chad Williamson wrote:
> Replace the bpctl_dev_t typdef in bpctl_mod.c with struct bpctl_dev
> for coding style compliance.

This patch doesn't apply to my tree, care to refresh it against the
latest staging-next branch and resend it, and the rest of the patches in
this series?

thanks,

greg k-h
