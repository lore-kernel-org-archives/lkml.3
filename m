Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab3LIQUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:20:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59596 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab3LIQUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:20:39 -0500
Message-ID: <52A5EDD4.20506@ti.com>
Date: Mon, 9 Dec 2013 11:20:36 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC v1 0/9] gpio: davinci: reuse for keystone arch
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com> <CACRpkdYKRWZJm8nRGSHV8DUehd9d0rh6y8R4HMvkimKhWezD2g@mail.gmail.com>
In-Reply-To: <CACRpkdYKRWZJm8nRGSHV8DUehd9d0rh6y8R4HMvkimKhWezD2g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar,

On Friday 29 November 2013 03:37 AM, Linus Walleij wrote:
> On Tue, Nov 26, 2013 at 8:40 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> 
>> [1] Depends on patch:
>> "[PATCH 1/2] gpio: davinci: Fix a check for unbanked gpio"
>> https://lkml.org/lkml/2013/11/8/22
>>
>> [2] and depends on series from Prabhakar Lad:
>> "[PATCH v6 0/6] gpio: daVinci: cleanup and feature enhancement"
>> https://www.mail-archive.com/devicetree@vger.kernel.org/msg05970.html
> 
> So this needs to go through the same tree as these patches.
> 
> And I suggested that Sekhar queue them and either take them
> directly up to ARM SoC or send me a pull request to take it through
> the GPIO tree.
> 
Are you going to collect all the Davinci gpio patches create a pull
request for Linus Walleij ?

Let us know so that if needed, we can put these patches together
on a tree for Linus W to pull from.

I would like to get these patches in 3.14 queue. Thanks

Regards,
Ssantosh
