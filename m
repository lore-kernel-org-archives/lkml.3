Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaCOHiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 03:38:10 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49246 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaCOHiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 03:38:06 -0400
Message-ID: <53240327.8070507@ahsoftware.de>
Date: Sat, 15 Mar 2014 08:37:11 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
References: <5316FFCE.1060603@ti.com>	<1394018461-757-1-git-send-email-holler@ahsoftware.de>	<CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com>	<5322D529.4070904@ahsoftware.de>	<CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>	<5322F82A.9000507@ahsoftware.de>	<CACRpkdZscprsy7kyqHPUMEMYJ_TKgG2bYR7mdrG4hTDp1w1nDg@mail.gmail.com>	<53234B68.5090300@ahsoftware.de> <CACRpkdZ2+kfOim1OEWbYR_Tj36i+8HmYXh+nqO9h1Em8gqy=3Q@mail.gmail.com>
In-Reply-To: <CACRpkdZ2+kfOim1OEWbYR_Tj36i+8HmYXh+nqO9h1Em8gqy=3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.03.2014 20:52, schrieb Linus Walleij:

> So a few Tested-by's from the people using this driver would for
> example convince me that it is solving a real problem for them
> and it needs to go into fixes.

2001: a space odyssey is fast action movie compared with the movie 
kernel bug fixing. And 2001 is a masterpiece of slowness.

Regards,

Alexander Holler

