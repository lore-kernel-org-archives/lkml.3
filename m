Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbaGOInC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:43:02 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60320 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbaGOIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:42:58 -0400
Message-ID: <53C4E989.9020103@linux.vnet.ibm.com>
Date: Tue, 15 Jul 2014 16:42:49 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "dongsu.park@profitbricks.com" <dongsu.park@profitbricks.com>,
        "jet.chen@intel.com" <jet.chen@intel.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "hch@lst.de" <hch@lst.de>, "kmo@daterainc.com" <kmo@daterainc.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "axboe@fb.com" <axboe@fb.com>
Subject: Re: Bug_ON with patch: bio: modify __bio_add_page() to accept pages
 that don't start a new segment
References: <53C4E2F0.8000307@linux.vnet.ibm.com> <E83EB052-8DC9-4B0E-830D-AF7A2557BEF6@kernel.dk>
In-Reply-To: <E83EB052-8DC9-4B0E-830D-AF7A2557BEF6@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071508-0260-0000-0000-0000055DFDED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 04:41 PM, Jens Axboe wrote:
> On 15/07/2014, at 10.14, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
>> My Power7 box boot fail with commit:
>>
>> 254c4407cb84a6dec90336054615b0f0e996bb7c
>> bio: modify __bio_add_page() to accept pages that don't start a new segment
>>
>> Just revert it will works for me.
> I have reverted it yesterday in my tree.
>

OK, that's fine :)

Thanks
Mike

