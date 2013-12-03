Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3LCAk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:40:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab3LCAky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:40:54 -0500
Message-ID: <529D286C.30908@ti.com>
Date: Mon, 2 Dec 2013 19:40:12 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 00/24] mm: Use memblock interface instead of bootmem
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com> <5298C5C2.60008@ti.com> <20131202163234.3edcb8e77834322314c435ea@linux-foundation.org>
In-Reply-To: <20131202163234.3edcb8e77834322314c435ea@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 December 2013 07:32 PM, Andrew Morton wrote:
> On Fri, 29 Nov 2013 11:50:10 -0500 Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> 
>> Tejun, Andrew,
>>
>> On Friday 08 November 2013 06:41 PM, Santosh Shilimkar wrote:
>>> Tejun and others,
>>>
>>> Following up with the earlier RFC [1] comments, here is the updated
>>> patch series based on the discussion. This series is the last bottleneck
>>> now for me to enable the coherency on keystone ARM LPAE architecture on which
>>> the physical memory starts after 4BG. I would like to get these patches
>>> in next merge window(3.14), so any help in terms of testing/comments is
>>> appreciated.
>>>
>> Now since the 3.13-rc1 is out, it will be best to apply these patches 
>> on memblock tree so that they start appearing in next to catch any
>> regressions, issues etc. It will give us some time to fix any issues
>> arises from next.
>>
>> For convenience, I have re-based the series on top of 3.13-rc1 and
>> pushed it on below tree.
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
>> for_3.14/memblock
>>
>> web-url:
>> https://git.kernel.org/cgit/linux/kernel/git/ssantosh/linux-keystone.git/log/?h=for_3.14/memblock
>>
>> Can you please pull these in you tree and apply against your
>> next branch ?
> 
> It would cause me much joy if yinghai were able to find time to review
> all this.  The patches are a bit old now, so perhaps a resend will help.
> 
OK. I will re-send the patchset.

Regards,
Santosh
