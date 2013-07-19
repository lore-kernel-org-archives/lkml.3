Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836Ab3GSRKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:10:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35276 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GSRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:10:24 -0400
Message-ID: <51E972FE.6060402@free-electrons.com>
Date: Fri, 19 Jul 2013 19:10:22 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, marex@denx.de, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
Subject: Re: [PATCH v2 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <1374225208-28940-3-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374225208-28940-3-git-send-email-hector.palacios@digi.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/2013 11:13, Hector Palacios wrote:
> Some LRADC channels have fixed pre-dividers so they can measure
> different voltages at full scale. The reference voltage allows to
> expose a scaling attribute through the IIO sysfs so that a user can
> compute the real voltage out of a measured sample value.
>
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>



-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

