Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967142AbaFTLUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:20:46 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61059 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967028AbaFTLUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140619225100.GA15258@kroah.com>
References: <1402788921-15458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1402788921-15458-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140619225100.GA15258@kroah.com>
Date: Fri, 20 Jun 2014 13:20:43 +0200
Message-ID: <CAFo99gZKXEVVxZX12pqiaPuD2RqN=qxkKezSoP09ECSj37waSA@mail.gmail.com>
Subject: Re: [PATCH] staging: imx-drm: ipu-v3: ipu-common.c: Cleaning up
 return of uninitialized variable
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The mainline form about Jun 6.
And now it is in  drivers/gpu/ipu-v3/ipu-common.c
Still with the same error.

Sorry, I have started to compare to linux-next, but I do it as:
diff `find . ../linux-next/ -name ipu-common.c`
So missed that the file had moved :-/

Ok, I send a new patch then..


Kind regards
Rickard Strandqvist


2014-06-20 0:51 GMT+02:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Sun, Jun 15, 2014 at 01:35:21AM +0200, Rickard Strandqvist wrote:
>> Before when there was an error a uninitialized variable would be returnd.
>> Now it returns -ENODEV
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/imx-drm/ipu-v3/ipu-common.c |    4 ++--
>
> This file isn't even in the tree anymore, what did you make this patch
> against?
