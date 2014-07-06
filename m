Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaGFVHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 17:07:16 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44241 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGFVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 17:07:13 -0400
X-Auth-Info: 1v7axqcmQCy3eldcZlb2jgbHZe9HjCnmYG1a5pUS8mo=
From: Marek Vasut <marex@denx.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] video: fbdev: mxsfb.c:  Cleaning up variable that is never used
Date: Sun, 6 Jul 2014 23:06:59 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>,
        Jingoo Han <jg1.han@samsung.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1404672272-19231-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1404672272-19231-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407062306.59317.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 06, 2014 at 08:44:32 PM, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Makes perfect sense.

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
