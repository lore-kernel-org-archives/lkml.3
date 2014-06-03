Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbaFCRJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:09:32 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40962 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714AbaFCRJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:09:31 -0400
Message-ID: <538E0144.1050700@gmail.com>
Date: Tue, 03 Jun 2014 20:09:24 +0300
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/base: Replace alias if it already exists
References: <1401624083-30796-1-git-send-email-ivo.g.dimitrov.75@gmail.com>	<20140602145959.7E669C426F6@trevor.secretlab.ca>	<538CA125.7090906@gmail.com> <20140603085325.490A1C4096E@trevor.secretlab.ca> <538D9C42.9040707@gmail.com>
In-Reply-To: <538D9C42.9040707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On  3.06.2014 12:58, Ivaylo Dimitrov wrote:
>
>
> On  3.06.2014 11:53, Grant Likely wrote:
>
[...] Can you try putting the following into your board dts file
>> and see if it works?
>>
>> aliases {
>>     i2c0;        /* Deactivate the old alias by making it blank */
>>     i2c1 = &i2c1;
>>     i2c2 = &i2c2;
>>     i2c3 = &i2c3;
>>     i2c4 = &i2c4;
>>     i2c5 = &i2c5;
>> };
>>
>> g.
>>
>
> Will do, as soon as I get back home.
>
> Thanks,
> Ivo

Seems to fix the problem (tested it with qemu), will send a proper patch.

Thanks!,
Ivo
