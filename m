Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaJCPuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:50:52 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:46166 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbaJCPur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <1412350035.3795.101.camel@sauron.fi.intel.com>
References: <1412089998-18978-1-git-send-email-tlinder@codeaurora.org>
	<1412350035.3795.101.camel@sauron.fi.intel.com>
Date: Fri, 3 Oct 2014 17:50:46 +0200
Message-ID: <CACna6ryws=d_7NXhzWyu34TaV+Yv8y0+D4Q0ewuzDEv=8xDxRg@mail.gmail.com>
Subject: Re: [PATCH v2] mtd: ubi: Extend UBI layer debug/messaging capabilities
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2014 17:27, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> Yes, I guess a single patch is indeed OK. I have few nit-picks, though.
>
> On Tue, 2014-09-30 at 18:13 +0300, Tanya Brokhman wrote:
>> -             ubi_err("'ubi_io_read_ec_hdr()' returned unknown code %d", err);
>> +             ubi_err(ubi,
>> +               "'ubi_io_read_ec_hdr()' returned unknown code %d", err);
>>               return -EINVAL;
>
> I think it is fine if the line is long in these cases, let's keep the
> message on the same line, this split does not contribute to better
> readability, quite the opposite, in my opinion.
>
> One line:
> ubi_err(ubi, "long line")
>
> Multiple lines:
> ubi_err(ubi, "long line,
>         parameters)

You should discuss that with checkpatch team, because ARAIR it will
complain about "long line" with any other parameter in the same line.
