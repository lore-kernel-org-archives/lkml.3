Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaKJIkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:40:10 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:62600 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaKJIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:40:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] ASoC: simple-card: add multi-CODECs in DT
Date: Mon, 10 Nov 2014 09:39:57 +0100
Message-ID: <3271244.uSgBKXChSS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <d49d348da24fbd96e7be51ba2839ee8bc821ddec.1415605717.git.moinejf@free.fr>
References: <cover.1415605716.git.moinejf@free.fr> <d49d348da24fbd96e7be51ba2839ee8bc821ddec.1415605717.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T50wLCCyBZDTzNR77sA83FF4M+BZNeTgEkDfXUYFf8u
 q+WSVPrCF5zjaM2GytDg3+IDz0bP3yDYmcq5/Qi+iqndU+msb0
 Lh2sgb6iU3FaYzon6NkjiYKg8FGwavrdgeXVX1dL0KFGHJE+id
 kYG8wYISeyCDinWkEJ7auqVgb0jM2rdJ2BbSAT2H2bgval8Ptp
 IAyXaDITO+qtJWySTCkdv2S0FCjeUNlHFpY79VPQ7ouRepiL8B
 qlETkcXLv0U+BEBHRgyZ4obO0tHpoz001I4laA+5c2jQr5p18u
 XlUFdaGKU3ZkZISfc8BKoQUZJtrAziYTJI+SXx8zRe961W2qFM
 /3d4eFTDEORilLULCMww=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 November 2014 12:22:21 Jean-Francois Moine wrote:
> -- sound-dai                            : phandle and port of CPU/CODEC
> +either
> +  - sound-dai                          : phandle and port of CPU/CODEC
> +or
> +  - sound-dais                         : list of phandle and port of CODECs

Is it really necessary to change the property name here? I woudl think
that you can make it all work more consistently with just the existing
'sound-dai' property, just extend it to allow multiple codecs

	Arnd
