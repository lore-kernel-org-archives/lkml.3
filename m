Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaDWMjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:39:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:60047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaDWMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:39:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 6/8] ARM: sun6i: Sort the NMI node by physical address
Date: Wed, 23 Apr 2014 14:39:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, andriy.shevchenko@intel.com,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com> <1397724379-15398-7-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1397724379-15398-7-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231439.26549.arnd@arndb.de>
X-Provags-ID: V02:K0:sCtP/xHFh+eSbUbjryCAAhAluLrMZfRW7nNcgNmrPdP
 jBejdT0fqSnpbSQRQ7flpsPoyVi2LrjorLZGQNqlA8yrshPepM
 Bj+r3quVHFl7xYeFfGzKcWRqbM2uGhAZ78kpGeRKR/nd4vOVRy
 f6S8A6mnTGDTtWy2xH6Ou1SXfdtCIKyg0F3G3A6ay6CoclR3sr
 57E5jCvqFhYi2jGkph4tCe+vaMlRd8sobB4sWdCyf/EPHG10zm
 kFk/v1XKP1YSOtptxFcmM5+f0PsJen2NKaO/7aOE3yOz/a3XeH
 W96Vot3snVJdAHWUZlQiqg6aECKN2616yQHC6CpAghoWeVi4G7
 DKRW69HNo0+aoI2S6jac=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014, Maxime Ripard wrote:
> The DT are supposed to be ordered by physical address. Move the NMI node where
> it belongs.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
