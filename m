Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaIFPrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:47:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35302 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIFPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:47:28 -0400
Message-ID: <540B2C84.5000002@oracle.com>
Date: Sat, 06 Sep 2014 11:47:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linuxfoundation.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 5: build failure due to 'mm: introduce
 dump_vma'
References: <20140905165052.GF29327@sirena.org.uk> <20140906154309.GB25739@roeck-us.net>
In-Reply-To: <20140906154309.GB25739@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2014 11:43 AM, Guenter Roeck wrote:
> I see the following build failure in next-20140905.
> 
> Guenter

Hey Guenter,

Apologies for that. There is already a fix in -mm:

	http://ozlabs.org/~akpm/mmots/broken-out/introduce-dump_vma-fix-2.patch

So -next would be fixed once -mm is pulled in again.


Thanks,
Sasha
