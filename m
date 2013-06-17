Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3FQF3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:29:51 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53928 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3FQF3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <51A852A1.7020505@monstr.eu>
References: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com>
	<CACRpkdY4xaCOe28nu-NrYQ7pafjhj8-xqFcJRF9iJUy3SrCVrA@mail.gmail.com>
	<51A8387C.4030704@monstr.eu>
	<CACRpkdbHiaK6YPgXyxNgEeZxAsddK4x0vS-q3YfyXnj_BgHvuw@mail.gmail.com>
	<51A852A1.7020505@monstr.eu>
Date: Mon, 17 Jun 2013 07:29:49 +0200
Message-ID: <CACRpkdbL4pqiF8zxMi28SRTJ9AESiFt0wJMhK1oBio_cfFhpsQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] GPIO: Add support for dual channel in gpio-xilinx.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 9:34 AM, Michal Simek <monstr@monstr.eu> wrote:
> On 05/31/2013 09:14 AM, Linus Walleij wrote:

>> It's OK, but fix the boolean member so as to just needing to
>> be present:
>>
>> xlnx,is-dual;
>>
>> Rather than
>>
>> xlnx,is-dual = <1>;
>
> Surely I can do it but it means to change our BSP and because
> this IP is used on Microblaze from beginning this change
> breaks all DTSes from past.

I think of_property_read_bool() will accept
xlnx,is-dual = <1>; to mean the same as xlnx,is-dual;
try it.

Yours,
Linus Walleij
