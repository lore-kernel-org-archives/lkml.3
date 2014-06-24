Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaFXVrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:47:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:65429 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaFXVrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:47:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,540,1400050800"; 
   d="scan'208";a="562849401"
Date: Tue, 24 Jun 2014 15:47:11 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>, Ming Lei <tom.leiming@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v8] NVMe: convert to blk-mq
In-Reply-To: <CAOu_J6mz=eeimXAsQ0Mj=tya+eHpwUoiG69=XPWbSEuRO1AwjA@mail.gmail.com>
Message-ID: <alpine.LRH.2.03.1406241531350.4699@AMR>
References: <1402661396-19207-1-git-send-email-m@bjorling.me> <1402661396-19207-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406160931400.4699@AMR> <53A9CF5F.6040806@bjorling.me> <alpine.LRH.2.03.1406241419080.4699@AMR>
 <CAOu_J6mz=eeimXAsQ0Mj=tya+eHpwUoiG69=XPWbSEuRO1AwjA@mail.gmail.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1839136328-1403646432=:4699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1839136328-1403646432=:4699
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 24 Jun 2014, Matias Bjørling wrote:
> On Tue, Jun 24, 2014 at 10:33 PM, Keith Busch <keith.busch@intel.com> wrote:
>> On Tue, 24 Jun 2014, Matias Bjorling wrote:
>>> Den 16-06-2014 17:57, Keith Busch skrev:
>>>>
>>>> This latest is otherwise stable on my dev machine.
>>>
>>> May I add an Acked-by from you?
>>
>> Totally up to Willy, but my feeling is "not just yet". I see the value
>> this driver provides, but I would need to give this to a customer and
>> hear their results before adding an "ack". It maybe a couple more weeks
>> before they'll be able to try it.
>
> I was hoping to get an OK before that, to make sure it is picked up
> for the 3.17 release.
>
> Should I pack it up in a specific way to help it along?

I think what you're doing is the right way to go. I trust you removed
the test code from your next iteration, and this does pass my tests on my
machine... I was just hoping to hear what some other people with better
macro level benchmarking abilities would say. So okay, you can put my
"Acked-by" on this, but I don't have all the performance numbers yet.
--8323328-1839136328-1403646432=:4699--
