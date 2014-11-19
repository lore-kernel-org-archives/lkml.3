Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaKSB1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:27:16 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59067 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882AbaKSB1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:27:13 -0500
Date: Wed, 19 Nov 2014 09:26:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH V2 0/2] Add I2C and enable M41T0M6 RTC
Message-ID: <20141119012647.GB24042@dragon>
References: <cover.1415852424.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1415852424.git.bhuvanchandra.dv@toradex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:05:30AM +0530, Bhuvanchandra DV wrote:
> Add I2C support on Colibri VFxx moduels and enable M41T0M6 RTC
> available on Colibri carrier boards.
> 
> Bhuvanchandra DV (2):
>   ARM: dts: vf-colibri: Add I2C support
>   ARM: dts: vf-colibri-eval-v3.dts: Enable ST-M41T0M6 RTC

Applied both, thanks.

> 
>  arch/arm/boot/dts/vf-colibri-eval-v3.dtsi |   12 +++++++++++-
>  arch/arm/boot/dts/vf-colibri.dtsi         |   13 +++++++++++++
>  2 files changed, 24 insertions(+), 1 deletion(-)
> 
> -- 
> 1.7.9.5
> 
