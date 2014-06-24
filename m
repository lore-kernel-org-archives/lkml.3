Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaFXV5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:57:38 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64183 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaFXV5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:57:36 -0400
MIME-Version: 1.0
X-Originating-IP: [80.196.35.44]
In-Reply-To: <alpine.LRH.2.03.1406241531350.4699@AMR>
References: <1402661396-19207-1-git-send-email-m@bjorling.me>
	<1402661396-19207-2-git-send-email-m@bjorling.me>
	<alpine.LRH.2.03.1406160931400.4699@AMR>
	<53A9CF5F.6040806@bjorling.me>
	<alpine.LRH.2.03.1406241419080.4699@AMR>
	<CAOu_J6mz=eeimXAsQ0Mj=tya+eHpwUoiG69=XPWbSEuRO1AwjA@mail.gmail.com>
	<alpine.LRH.2.03.1406241531350.4699@AMR>
Date: Tue, 24 Jun 2014 23:57:35 +0200
Message-ID: <CAOu_J6mS=Wq5OBYsWrrWfvfjTXkgo3ZDdNLTJC7aaGgG=iUAaQ@mail.gmail.com>
Subject: Re: [PATCH v8] NVMe: convert to blk-mq
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Keith Busch <keith.busch@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>, Ming Lei <tom.leiming@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:47 PM, Keith Busch <keith.busch@intel.com> wrote:
> On Tue, 24 Jun 2014, Matias Bjørling wrote:
>>
>> On Tue, Jun 24, 2014 at 10:33 PM, Keith Busch <keith.busch@intel.com>
>> wrote:
>>>
>>> On Tue, 24 Jun 2014, Matias Bjorling wrote:
>>>>
>>>> Den 16-06-2014 17:57, Keith Busch skrev:
>>>>>
>>>>>
>>>>> This latest is otherwise stable on my dev machine.
>>>>
>>>>
>>>> May I add an Acked-by from you?
>>>
>>>
>>> Totally up to Willy, but my feeling is "not just yet". I see the value
>>> this driver provides, but I would need to give this to a customer and
>>> hear their results before adding an "ack". It maybe a couple more weeks
>>> before they'll be able to try it.
>>
>>
>> I was hoping to get an OK before that, to make sure it is picked up
>> for the 3.17 release.
>>
>> Should I pack it up in a specific way to help it along?
>
>
> I think what you're doing is the right way to go. I trust you removed
> the test code from your next iteration, and this does pass my tests on my
> machine... I was just hoping to hear what some other people with better
> macro level benchmarking abilities would say. So okay, you can put my
> "Acked-by" on this, but I don't have all the performance numbers yet.

Thanks. Yes, agree. I'll also send the patch to a couple of people
that have nvme devices for further testing.
