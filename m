Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaLCJwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:52:04 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57575 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaLCJwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:52:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Xiubo Li <Li.Xiubo@freescale.com>, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        alexander.stein@systec-electronic.com
Subject: Re: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Date: Wed, 03 Dec 2014 10:51:53 +0100
Message-ID: <4810522.t9QFQYHtHI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:X/B/ylGVzmzbFJ8Q/pVYj4Q+8fPIfV0vwEIkR4gIsKV
 IX8emR5B7gFyxgFv29RNlPOyhLD+bo++IZ10/SY3RKlSK8RYaX
 OHLb/jAjkn1eq9FOzG9LGnJVVBFYmpl4LYhKlDS3HhkDGvJRce
 xtk34ao9hKNFeU5QWlPcnsvFdme0S85j63fnlApn/48ZJB07L7
 7y7KAWEqdqgxv5/qOrkGP2/i2C93dVahvhs0vYyhc/o2DLopOr
 40jSRxMOJrnt8qoV31gc0WoWjgpHwHHzprrIddsX0u/R/KRur4
 V/v3bmsvg6AtkEqpNDu23u2rnhyGL2UOaIFl7RZJU5exHjHERD
 bK4P8HJaexCSAPslv8H8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 17:15:58 Xiubo Li wrote:
> Framebuffer driver for the Freescale SoC Display Controller.
> 
> 
> Change in V2:
> - Use the native-mode timing as default.
> - Add to_fsl_private().

<standard reply>

We try to not have any new framebuffer drivers. Please consider making
this a DRM/KMS driver instead.

</standard reply>

	Arnd
