Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaIKLl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:41:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36239 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbaIKLl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:41:57 -0400
Message-ID: <54118A7E.4090902@collabora.co.uk>
Date: Thu, 11 Sep 2014 13:41:50 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Nick Dyer <nick.dyer@itdev.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk> <540ED495.20609@collabora.co.uk> <20140910092832.GM30307@lee--X1> <1410422429.2857.16.camel@collabora.co.uk> <54115F6E.3010007@collabora.co.uk> <5411693A.3050300@itdev.co.uk> <20140911110829.GA5149@katana> <54118687.8040802@collabora.co.uk> <20140911113548.GB5149@katana>
In-Reply-To: <20140911113548.GB5149@katana>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

On 09/11/2014 01:35 PM, Wolfram Sang wrote:
> 
>> > This is a workaround. It would make sense, however, to add it because we
>> > want to support i2c_board_info structures.
>> > 
>> 
>> I think it really depends if an IP block can be used on non-DT platforms
>> (which I think is true for this trackpad) but if a driver is for an IP block
>> that can only be used on a DT-only platform (e.g: a PMIC that is controlled
>> over I2C and is only compatible with a DT-only SoC) then I don't think we need
>> to support the i2c_board_info structure and can get rid of the I2C ID table on
>> these drivers once Lee series land.
> 
> That is exactly what I meant. It should be only added if there is a
> reason other than "workaround". If you say, it doesn't make sense on
> non-DT, then it should not be added.
> 

Sorry for explaining myself badly. I just tried to say that this is a decision
that has to be made on a per-driver basis but I don't really know if makes
sense or not in this case since I don't know if this device is (or could be)
shipped on non-DT platforms. Nick is in a much better position to answer that
question.

Best regards,
Javier
