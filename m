Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3FMPbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:31:47 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63116 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3FMPbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:31:46 -0400
MIME-Version: 1.0
In-Reply-To: <201306131635.21446.heiko@sntech.de>
References: <201306102139.32444.heiko@sntech.de>
	<201306130022.29341.heiko@sntech.de>
	<CACRpkdb-vbdQJOeZvCEsKLatK-0BhEfUTJqmGURJGf1NWx__Ew@mail.gmail.com>
	<201306131635.21446.heiko@sntech.de>
Date: Thu, 13 Jun 2013 17:31:45 +0200
Message-ID: <CACRpkdZw+3BQdVm2w6wzqy5LFO0Yw8avQLiB0hxtspvShPbk0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig
 properties from a dt node
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: James Hogan <james.hogan@imgtec.com>,
        Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 4:35 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Donnerstag, 13. Juni 2013, 10:11:28 schrieb Linus Walleij:
>> Tisdagen den 13:e Juni 2013 klock 12:22 AM, skrev Heiko Stübner

>> > The only other candidate I could find was low-power-mode which really
>> > could use a "1" as default. All the other pinconf options either use
>> > custom arguments or ignore teir argument.
>>
>> A "1" for what? Not quite following....
>
> According to the pinconf header docs, low-power-mode also expects an argument
> of 1 or 0. So it's default value should change too ... or we could rename the
> property, like "low-power-enable" and "low-power-disable", which might make
> the dt more readable than an arbitary low-power-mode = <0>;

Oh yes, sorry, of course. Go ahead with this.

Yours,
Linus Walleij
