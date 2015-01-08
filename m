Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbbAHA7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:59:40 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:1884 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752409AbbAHA7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:59:39 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="55718343"
Message-ID: <54ADD298.9050806@cn.fujitsu.com>
Date: Thu, 8 Jan 2015 08:43:04 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 1/3] mtd:mtdblock: remove the needless mtdblks_lock
References: <547E7348.5020204@cn.fujitsu.com> <20150107205926.GO9759@ld-irv-0074>
In-Reply-To: <20150107205926.GO9759@ld-irv-0074>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,
On 01/08/2015 04:59 AM, Brian Norris wrote:

> On Wed, Dec 03, 2014 at 10:19:52AM +0800, Gu Zheng wrote:
>> The global lock mtdblks_lock was used to protect the original mtdblks
>> array to avoid race conditions. As the mtdblks array was already gone,
>> but the mtdblks_lock is left, and it causes latency when open/release dev.
>> So we need to remove it here.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Pushed this first patch to l2-mtd.git. Thanks!

Thanks.

> 
> I'm kinda ambivalent about the next two. They don't seem like necessary
> cleanups, really. With the third patch, I think it's actually pretty
> important that the caller understand that it's using container_of(). I
> could be convinced otherwise though...

OK.

Regards,
Gu

> 
> Brian
> 


