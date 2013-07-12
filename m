Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3GLL3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:29:19 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57022 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3GLL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130712110047.GA3135@katana>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
	<20130705195512.GJ27646@sirena.org.uk>
	<CAHp75VeasHGariq=v005NSUTe_+e471NYbEoSzPJXcFNgsfKNQ@mail.gmail.com>
	<20130712110047.GA3135@katana>
Date: Fri, 12 Jul 2013 14:29:16 +0300
Message-ID: <CAHp75Ve8oLeT=-_t96i_ctcmnM4kEPHD0cBjBroJTnYxwczBmw@mail.gmail.com>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Brown <broonie@kernel.org>, Bin Gao <bin.gao@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 2:00 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> Briefly looking into ACPI tables we have and mechanisms that we can
>> use in ACPI case, I doubt we may apply all the ideas, probably some of
>> them, though I didn't get yet where to read about in details. What I
>> could say now is that the patch provided by Bin Gao is definitely no
>> go.
>
> Laurent explained to me what V4L did and now does. It used to be the way
> tha V4L drivers did register I2C slaves according to platform_data. Now,
> with DT the slaves get instanciated earlier, so they now use notifiers
> to know when the slaves are in place. Something like this should
> probably be done here, too, instead of unregistering and re-registering.

Yes, seems right way to go.
I think ACPI case can use V4L2 async API somehow, though it has its
own event model.
I'll talk to Sakari Ailus to sync.

--
With Best Regards,
Andy Shevchenko
