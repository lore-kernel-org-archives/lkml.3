Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3K2Q2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:28:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50205 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab3K2Q2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:28:52 -0500
Message-ID: <5298C0C2.10209@ti.com>
Date: Fri, 29 Nov 2013 11:28:50 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC v1 5/9] gpio: davinci: reuse for Keystone SoC
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com> <1385494815-15740-6-git-send-email-grygorii.strashko@ti.com> <CACRpkda=5KyvRpN=O5UHhX8S-jYB-0g3272Xg61_jvpCEb7Nzg@mail.gmail.com>
In-Reply-To: <CACRpkda=5KyvRpN=O5UHhX8S-jYB-0g3272Xg61_jvpCEb7Nzg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 November 2013 04:25 AM, Linus Walleij wrote:
> On Tue, Nov 26, 2013 at 8:40 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> 
>> The similar GPIO HW block is used by keystone SoCs as
>> in Davinci SoCs.
>> Hence, reuse Davinci GPIO driver for Keystone.
>>
>> Documentation:
>>  http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> This is really nice, and we want to reuse stuff.
> 
Ofcourse we want to re-use as much as possible.

> Just waiting for some comments on the previous patch...
> 
Previous patch can be completely dropped as commented.

Regards,
Santosh

