Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3FQJNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:13:41 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:34901 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3FQJNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <51BEAAF5.6070003@monstr.eu>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
	<af7595252de09373f5591f21262e5ffa7c9e0dc2.1370262666.git.michal.simek@xilinx.com>
	<CACRpkdaaZKyqBeJHnL4Q5vc3ZVa_psF61McJ2wsFQJMTGvn-NA@mail.gmail.com>
	<51BEAAF5.6070003@monstr.eu>
Date: Mon, 17 Jun 2013 11:13:39 +0200
Message-ID: <CACRpkdZwbc2pU7m5rWTbnkGRoRY+jQX8x3=s8MmE46Vjj4S8JQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] DT: Add documentation for gpio-xilinx
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 8:21 AM, Michal Simek <monstr@monstr.eu> wrote:
> On 06/17/2013 07:50 AM, Linus Walleij wrote:
>> On Mon, Jun 3, 2013 at 2:31 PM, Michal Simek <michal.simek@xilinx.com> wrote:

>>> +- xlnx,tri-default : if n-th bit is 1, GPIO-n is in tristate mode
>>> +- xlnx,is-dual : if 1, controller also uses the second channel
>>
>> If is present, xlnx,is-dual;
>>
>>> +       xlnx,is-dual = <0x1>;
>>
>> xlnx,is-dual;
>>
>> I'm not giving up on this suggestion.
>
> I have commented this in the v1.

I commented your comment on v1, and said I think you can support
both bindings.

Yours,
Linus Walleij
