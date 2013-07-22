Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3GVWgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:36:47 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57823 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3GVWgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:36:45 -0400
X-Auth-Info: zC3O2kvO+jm8uCiyuOUPxsuG/aDtw86H/rK0nJd8dSo=
From: Marek Vasut <marex@denx.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS LRADC
Date: Tue, 23 Jul 2013 00:06:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: Hector Palacios <hector.palacios@digi.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        fabio.estevam@freescale.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com> <1374501843-19651-3-git-send-email-hector.palacios@digi.com> <51ED7B47.2090104@metafoo.de>
In-Reply-To: <51ED7B47.2090104@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307230006.53434.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lars-Peter Clausen,

> On 07/22/2013 04:04 PM, Hector Palacios wrote:
> > Some LRADC channels have fixed pre-dividers so they can measure
> > different voltages at full scale. The reference voltage allows to
> > expose a scaling attribute through the IIO sysfs so that a user can
> > compute the real voltage out of a measured sample value.
> 
> I've said before that I'm not convinced that this is the right way to
> implement this. And considering what Thomas said here
> http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg36691.ht
> ml I guess I'm not alone with that opinion.
> 
> - Lars

He's talking about different versions of the IP block, this is the same IP 
block, just connected to different inputs.

Best regards,
Marek Vasut
