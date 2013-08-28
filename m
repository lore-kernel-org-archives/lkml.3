Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3H1DJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 23:09:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3H1DJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 23:09:04 -0400
Date: Tue, 27 Aug 2013 20:11:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: s.hauer@pengutronix.de, p.zabel@pengutronix.de, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
Message-ID: <20130828031122.GA11625@kroah.com>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377657163-6606-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:32:43PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
> failure is seen:

I don't have that commit in any tree I control, so I can't apply this
patch.  What tree is this commit in?

thanks,

greg k-h
