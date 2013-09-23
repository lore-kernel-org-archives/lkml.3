Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3IWIJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:09:55 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:62912 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3IWIJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:09:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130923080532.GD2185@lee--X1>
References: <1379879358-7297-1-git-send-email-linus.walleij@linaro.org>
	<20130923080532.GD2185@lee--X1>
Date: Mon, 23 Sep 2013 10:09:53 +0200
Message-ID: <CACRpkdaytQMhPRK59nrXDFhY7e1UyYC3X461-LS-5xymgM36sw@mail.gmail.com>
Subject: Re: [PATCH v3] mfd: add STw481x driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:05 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Nit:
>
>> +static const struct i2c_device_id stw481x_id[] = {
>> +     { "stw481x", 0 },
>> +     { }
>
> Where we have '{ }'.
>
>> +};
>> +
>> +static const struct of_device_id stw481x_match[] = {
>> +     { .compatible = "st,stw4810", },
>> +     { .compatible = "st,stw4811", },
>> +     {},
>
> And just down here the same function is provided with '{},'.
>
> I'm happy to change it myself, rather that asking you to resubmit.
>
> Which to you prefer?

Pls fix it if you have time!

Yours,
Linus Walleij
