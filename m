Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3E3LzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:55:20 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46669 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3E3LzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:55:14 -0400
MIME-Version: 1.0
In-Reply-To: <51A6F9D9.30900@dev.rtsoft.ru>
References: <1369827913-31033-1-git-send-email-n.a.balandin@gmail.com>
	<CAHp75VdmKih7VLGDGMZ8CNCzWFE38TC-sUZOGvq-yqFN1YmkDA@mail.gmail.com>
	<51A6F9D9.30900@dev.rtsoft.ru>
Date: Thu, 30 May 2013 14:55:12 +0300
Message-ID: <CAHp75VfHN_8s7gx=a0TLkkPgeZx=cvcXwbfFQPYPG0XDEW-zJA@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] drivers/misc: lis3lv02d: convert to use devm_regulator_bulk_get
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Cc: Nikolay Balandin <n.a.balandin@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:03 AM, Nikolay Balandin
<nbalandin@dev.rtsoft.ru> wrote:

>   Yes, this accelerometer is present on the Kontron SMARC evaluation
> carrier.
> http://emea.kontron.com/products/computeronmodules/smarc/smarc+evaluation+carrier.html

Good.

I think you may do following things:
- update lis3lv02d.c to  use devm_* functions
- and then update i2c driver to use devm_*

Are you going to support that platform via DeviceTree model?

> On Wed, May 29, 2013 at 2:45 PM, Nikolay Balandin
> <n.a.balandin@gmail.com> wrote:
> Use devm_regulator_bulk_get to make cleanup paths simpler
>
> Do you plan to use this driver somewhere outside of Nokia n900 device?
> If so, there is more than this clean up to do.
>
> Otherwise I don't think we have to touch that driver at all.


--
With Best Regards,
Andy Shevchenko
