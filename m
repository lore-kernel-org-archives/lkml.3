Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaJBP3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:29:31 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64531 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaJBP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:29:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, b35083@freescale.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: vf500/vf610: support VF500 SoC
Date: Thu, 02 Oct 2014 17:28:48 +0200
Message-ID: <8882221.sfQOLcQs3p@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412261724-11073-1-git-send-email-stefan@agner.ch>
References: <1412261724-11073-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LHr3eC11Oykpv7SdG5Bt8yUt4A/YStI24/+InlSzZjq
 3KNdoPodRMP8kfrh7q3joNGDkt3ojfX0RKGDsWsm6N19t/rJr2
 04vOZOhXIEhG2q6Indk32GuuIo/pAmkurnQQ3rMRucrxgKbnXd
 xkCbSIcNqSGeNBHGdk9Kwv8VeOvSGb//BP6L8UvW6rcppin7dt
 cWm2X16xKSfArGxkDf4elw1wOA/7b5lQXfJk0JPSA1ZstS5S34
 89ZlM9S3WEz+eGDyLr807iI3e3Dk4QDkKaZX9k+RojuKZcF+bq
 sOBx6WPM6U/wSVbyrjZrzNbM6Duro3zgcjSdRf53qi0598CC5S
 Oe+dgQHbzeJ3afwd2yaI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2014 16:55:23 Stefan Agner wrote:
> The VF500 is essentially the same SoC, but with only one core and
> without L1 cache. The VF610 is therefore a superset of the VF500.
> Move allmost all periperals to vf500.dtsi which is then included
> and enhanced by vf610.dtsi.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> Somehow using -M -B switches create a unapplyable patch, hence I
> generated one without those options. Sorry about that.
> 
>  arch/arm/boot/dts/vf500.dtsi | 498 ++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/vf610.dtsi | 507 +------------------------------------------
>  2 files changed, 510 insertions(+), 495 deletions(-)
>  create mode 100644 arch/arm/boot/dts/vf500.dtsi

I think it would be better to create one extra file that contains the common
parts and is included by both vf500 and vf610.

	Arnd
