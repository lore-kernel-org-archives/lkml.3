Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaCRJpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:45:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60195 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaCRJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:45:37 -0400
Message-ID: <532815A8.9090807@ahsoftware.de>
Date: Tue, 18 Mar 2014 10:45:12 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
References: <5316FFCE.1060603@ti.com> <1394018461-757-1-git-send-email-holler@ahsoftware.de> <CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com> <5322D529.4070904@ahsoftware.de> <CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com> <5326F8C5.5090406@ti.com> <CACRpkdYZMzw31NkA4uSq+ZowzOnZgZthXhZri-eJY2Ozb8aNRQ@mail.gmail.com> <532805AE.9000806@ti.com>
In-Reply-To: <532805AE.9000806@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.03.2014 09:37, schrieb Sekhar Nori:

> It is safe - at the least it does not break anything that is already
> working. I guess the decision to put it into -rc depends on whether you
> consider out of tree dtbs to be a valid usecase for the kernel.

That's all DT is about, getting rid of the necessity for in-tree 
hw-descriptions. ;)

But I don't need any rush here, I'm just unable to understand why the 
-rc phase isn't used for bug fixing as I believe that's what this phase 
is for.

Most people are unable to track the various -next trees, therefor many 
failures only come up when stuff reaches mainline where it might be 
tested by some more people. And if all bugs found in the -rc phase are 
fixed in -next only, the -rc phase would be useless.

And it just happened to me too often, that even silly bugfixes (like 
oneliners) needed between 5 and 9 months to reach a stable kernel and 
thus users.

Regards,

Alexander Holler
