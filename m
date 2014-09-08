Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaIHWNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:13:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaIHWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:13:54 -0400
Date: Mon, 8 Sep 2014 15:13:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hugues <morisset.hugues@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: lustre: fix coding style issues
Message-ID: <20140908221353.GA21671@kroah.com>
References: <540E27FB.2070206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540E27FB.2070206@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 12:04:43AM +0200, Hugues wrote:
> Fix coding style issues:
> * limit the length of changed lines to 80 columns.

Why isn't this in the body of the changelog?

> >From a244d32aa34d0b13ac40dd014b88d0ff5ed10817 Mon Sep 17 00:00:00 2001
> From: Hugues Morisset <morisset.hugues@gmail.com>
> Date: Mon, 8 Sep 2014 21:23:28 +0200
> Subject: [PATCH 1/4] staging: lustre: fix coding style issues
> 
> Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
> ---
>  drivers/staging/lustre/lustre/include/obd.h | 46 ++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 21 deletions(-)

I can't take patches in attachments, please put them in-line and use git
send-email to send them properly.

Please fix up and resend this whole series.

thanks,

greg k-h
