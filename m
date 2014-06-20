Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967382AbaFTMSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:18:05 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57848 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966858AbaFTMSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:18:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: syscon: Make it possible to mark syscon as read only
Date: Fri, 20 Jun 2014 14:17:58 +0200
Message-ID: <8049148.CC5WjPCMxf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403210626-4845-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1403210626-4845-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1WtYEX37PWj6K7knDx9euS5CrGiPpeo9Eyk5Yv27yB/
 vRBC1ZI9A6emDJULVjrLVGrgoqGex/b4MaMohR8LyZ+OM89iti
 sOLvsET1iG60cvqDdfNPL0h/2QRaaxjXjRzybukjY0bR6eD41m
 R0qV9LVNKf8Q3mLWkz7POs84tFGRoT99/M1j8nBFoCtbJ/ZmZN
 WPP3RpCfjoAPk9Zj8n3RMTS2PxBiOifq+wNHNO9FEu6Ad3TMXJ
 T5H1qJpahRZhmyHF/wZjbC+qUxt8wWqIcIqdrx58VRbjmYib0c
 HW+R8RxZSinXViaMkq7aWjC0KvIfJEj2Zh87NBtN8hRd+ABMPU
 pYZrFxpYK0MNzJYZDGQo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2014 13:43:46 Bjorn Andersson wrote:
> diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> index fe8150b..163325af0 100644
> --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> @@ -13,6 +13,9 @@ Required properties:
>  - compatible: Should contain "syscon".
>  - reg: the register region can be accessed from syscon
>  
> +Optional properties:
> +- read-only: the register region is read only
> +

We've been discussing devices that are simultaneously a
syscon and a more specific device. I'd suggest naming the
new property "syscon,read-only" here, so it becomes clearer
that this is a generic syscon property in that case.

	Arnd
