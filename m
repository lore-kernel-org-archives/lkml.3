Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3HWMcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:32:18 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:50436 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755011Ab3HWMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:32:14 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru 93ECC7F505
Date: Fri, 23 Aug 2013 16:32:00 +0400
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
To: Huang Ying <ying.huang@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemleak in apei_res_add
Message-ID: <20130823123159.GD12595@sanechka.spb.ru>
References: <20130812024556.GB29956@sanechka.spb.ru>
 <CAHkRjk4y06puTL_Gq5RbpoV+kpEp+k32z5aq3HpEu9u3qsS_Aw@mail.gmail.com>
 <20130821134455.GC12595@sanechka.spb.ru>
 <1377161014.6167.67.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377161014.6167.67.camel@yhuang-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Aug 22 16:43, Huang Ying wrote:
> Hi, Alexandra,
> Can you try the following debug patch, and send me back the output of:
> 
> $ dmesg | grep apei_res

bash$ dmesg |grep apei
[    9.608829] apei_res_add: ffff8802730cde48: 7dfd5018 - 7dfd5019
[    9.615354] apei_res_add: ffff8802730cde48: 7dfd5018 - 7dfd5019
[    9.621595] apei_res_add: ffff8802730cde48: 7dfd5018 - 7dfd5019
[    9.627915] apei_res_add: ffff8802730cde48: 7dfd5019 - 7dfd501a
[    9.634363] apei_res_add: ffff8802730cde48: 7dfd501a - 7dfd501e
[    9.640689] apei_res_add: ffff8802730cde58: b2 - b3
[    9.646008] apei_res_add: ffff8802730cde48: 7dfd501e - 7dfd501f
[    9.652320] apei_res_add: ffff8802730cde48: 7dfd501f - 7dfd5020
[    9.658637] apei_res_add: ffff8802730cde48: 7dfd5020 - 7dfd5028
[    9.664952] apei_res_add: ffff8802730cde48: 7dfd5028 - 7dfd5030
[    9.671227] apei_res_add: ffff8802730cde48: 7dfd5030 - 7dfd5032
[    9.686533] apei_res_add: ffff8802730cde48: 7dfd5018 - 7dfd5019
[    9.702283] apei_res_add: ffff8802730cde48: 7dfd5032 - 7dfd5033
[    9.718050] apei_res_add: ffff8802730cde48: 7dfd5032 - 7dfd503a
[    9.732699] apei_res_add: ffff8802730cde48: 7dfd503a - 7dfd503e
[    9.747231] apei_res_add: ffff8802730cde48: 7dfd503e - 7dfd503f
[    9.761822] apei_res_sub: ffff8802730cde48 - ffffffff81a76ee0
[    9.775718] apei_res_sub: ffff8802730cde58 - ffffffff81a76ef0
[    9.789058] apei_res_add: ffff8802730cdde8: 7e095000 - 7e299000
[    9.803780] apei_res_add: ffff8802730cdde8: 7f370000 - 7f3f6000
[    9.818264] apei_res_sub: ffff8802730cde48 - ffff8802730cdde8
[    9.831933] apei_res_sub: ffff8802730cde58 - ffff8802730cddf8
[    9.846091] apei_res_add: ffffffff81a76ee0: 7dfd5018 - 7dfd503f
[    9.859528] apei_res_add: ffffffff81a76ef0: b2 - b3

I hope it helps.

Alexandra.
-- 
Alexandra N. Kossovsky
OKTET Labs (http://www.oktetlabs.ru/)
e-mail: sasha@oktetlabs.ru
