Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3KUWVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:21:19 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52846 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3KUWVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:21:17 -0500
MIME-Version: 1.0
In-Reply-To: <528DFC81.2070000@gmail.com>
References: <1384984090-6772-1-git-send-email-delicious.quinoa@gmail.com>
	<528DFC81.2070000@gmail.com>
Date: Thu, 21 Nov 2013 16:21:15 -0600
Message-ID: <CANk1AXSFr+qzSLq-06TGyZkD=RBdQp3qwkvSXCbCtDQcqHqzPg@mail.gmail.com>
Subject: Re: [PATCH v7] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Heiko Stuebner <heiko@sntech.de>,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 6:28 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 11/20/2013 10:48 PM, Alan Tull wrote:
>>
>> From: Jamie Iles <jamie@jamieiles.com>
>>
>> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
>> and can be configured to provide multiple banks of GPIO pins.
>>
>> Signed-off-by: Alan Tull <atull@altera.com>
>
>
> Alan,
>
> I haven't looked as close as in the last reviews, but I think it is
> fine to have this version as a start. We can add platform_data and
> CONFIG_REG parsing later.
>
> Thanks for the patience, you can add my
>
> Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>

Thanks Sebastian!

Now I see one screwup on my part here - I did not mean to include
socfpga.dtsi changes in this patch.

Alan
