Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbaGOMBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:01:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321AbaGOMBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:01:49 -0400
Message-ID: <53C51819.3000704@redhat.com>
Date: Tue, 15 Jul 2014 14:01:29 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: ming.lei@canonical.com, dongsu.park@profitbricks.com, jet.chen@intel.com,
        viro@zeniv.linux.org.uk, hch@lst.de, kmo@daterainc.com,
        axboe@kernel.dk, akpm@linux-foundation.org, axboe@fb.com
Subject: Re: Bug_ON with patch: bio: modify __bio_add_page() to accept pages
 that don't start a new segment
References: <53C4E2F0.8000307@linux.vnet.ibm.com> <53C512B1.7060409@redhat.com>
In-Reply-To: <53C512B1.7060409@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/15/2014 01:38 PM, Maurizio Lombardi wrote:
> 
> 
> On 07/15/2014 10:14 AM, Mike Qiu wrote:
>> My Power7 box boot fail with commit:
>>
>> 254c4407cb84a6dec90336054615b0f0e996bb7c
>> bio: modify __bio_add_page() to accept pages that don't start a new segment
>>
>> Just revert it will works for me.
> 
> This looks strange to me because, even after reverting my patch, the kernel still panics
> with a different call trace:


Never mind, this is another bug in linux-next that is hit by cryptsetup.
Sorry for the noise.
