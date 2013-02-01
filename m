Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3BARLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:11:03 -0500
Received: from mail.prodrive.nl ([212.61.153.67]:17015 "EHLO mail.prodrive.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab3BARLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:11:00 -0500
Message-ID: <510BF720.5020708@prodrive.nl>
Date: Fri, 1 Feb 2013 18:10:56 +0100
From: Stef van Os <stef.van.os@prodrive.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111120 Icedove/3.1.16
MIME-Version: 1.0
To: <artem.bityutskiy@linux.intel.com>
CC: <dwmw2@infradead.org>, <wfp5p@virginia.edu>, <gregkh@linuxfoundation.org>,
        <sr@denx.de>, <plagnioj@jcrosoft.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mtd: physmap_of: fix illegal dereference
References: <1358446932-7238-1-git-send-email-stef.van.os@prodrive.nl> <1359737697.2942.16.camel@sauron.fi.intel.com>
In-Reply-To: <1359737697.2942.16.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.14.0.6]
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSVA-8.2.0.1520-7.0.0.1014-19606.000
X-TM-AS-Result: No--15.961-5.0-31-10
X-imss-scan-details: No--15.961-5.0-31-10
X-TM-AS-User-Approved-Sender: No
X-TMASE-Version: IMSVA-8.2.0.1520-7.0.1014-19606.000
X-TMASE-Result: 10--15.960900-5.000000
X-TMASE-MatchedRID: +c13yJDs900OwH4pD14DsPHkpkyUphL9wx0jRRxcQfOvVXRGKcI39g4W
	I34Fe9tzzIy4Q+OIZUdYcfwTkTa8k2GBe5Zc3tN271Wx2uUbPLfZph2fCfuod+2bjZi+EXNnKa4
	7QIW7gxx5xrAG0Ow0sLnE2ijtyO+/71zr0FZRMbA7qnMAZEGUXNmzcdRxL+xwKrauXd3MZDUD/d
	HyT/Xh7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 05:54 PM, Artem Bityutskiy wrote:
> On Thu, 2013-01-17 at 19:22 +0100, Stef van Os wrote:
>> d68cbdd introduced a new way of getting the name of an mtd
>> partion. The character pointer is not initialized, and only
>> checked against NULL, not at other random garbage.
>> This patch fixes the resulting panic.
>>
>> Signed-off-by: Stef van Os<stef.van.os@prodrive.nl>
> A similar fix already sits in the mtd tree:
>
> http://git.infradead.org/mtd-2.6.git/commit/7dfe4be351e81656ca1068e5d4ead235c7ba94b1
>
Ah, sorry, I wasn't aware of this. But, as long as some fix for this 
issue makes it into mainline, I'm happy :)
