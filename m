Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaFJWvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:51:43 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58726 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaFJWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:51:40 -0400
X-Auth-Info: 8okW4JFuJpL4Al6OvJ81mk6m3kPE4lZPHbH9Hb95p0k=
From: Marek Vasut <marex@denx.de>
To: Robert Hodaszi <robert.hodaszi@digi.com>
Subject: Re: [PATCH 1/2] iio: mxs-lradc: fix divider
Date: Wed, 11 Jun 2014 00:47:59 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, alexandre.belloni@free-electrons.com,
        jbe@pengutronix.de, hector.palacios@digi.com,
        fabio.estevam@freescale.com, lars@metafoo.de
References: <1402407695-2984-1-git-send-email-robert.hodaszi@digi.com> <1402407695-2984-2-git-send-email-robert.hodaszi@digi.com>
In-Reply-To: <1402407695-2984-2-git-send-email-robert.hodaszi@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201406110047.59372.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 at 03:41:34 PM, Robert Hodaszi wrote:
> All channels' single measurement are happening on CH 0. So enabling /
> disabling the divider once is not enough, because it has impact on all
> channels.
> 
> Set only a flag, then check this on each measurement, and enable / disable
> the divider as required.
> 
> Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
