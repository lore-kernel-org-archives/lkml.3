Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3ESOBC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 10:01:02 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:51725
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab3ESOBA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 10:01:00 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 May 2013 10:01:00 EDT
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Ic89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN1SVK-01-EC1-02
X-M-MSG: 
Message-ID: <5198D76C.7020500@amd.com>
Date: Sun, 19 May 2013 15:45:16 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Wolfram Gloger <wg@malloc.de>
Subject: Re: 3.9 breaks EFI boot on E350
References: <51935981.3010808@amd.com> <CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com> <5193A7C3.4010503@amd.com> <CAE9FiQV8x5NPBJVyiv0wE3jyqTvSMNWxgkDQRXf5LxifgCXbtw@mail.gmail.com> <5194A9CF.3080509@amd.com> <5194D5E6.2070605@amd.com> <CAE9FiQU4AQmQ6gzUK5gcnVebGPCNjAWFxh5=wXdEbZ_gHM4KaQ@mail.gmail.com> <5194F9DF.4030409@amd.com> <CAE9FiQWNDn8uHUAe+CSvYdJXeJi57G+9RBxs688+VaFRS-GXBA@mail.gmail.com> <5195FBBD.6060808@amd.com> <CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.05.2013 19:54, schrieb Yinghai Lu:
> On Fri, May 17, 2013 at 2:43 AM, Christian König
> <christian.koenig@amd.com> wrote:
>> Am 16.05.2013 17:42, schrieb Yinghai Lu:
>>
>>> On Thu, May 16, 2013 at 8:23 AM, Christian König
>>> <christian.koenig@amd.com> wrote:
>>>> Am 16.05.2013 17:17, schrieb Yinghai Lu:
>>>>
>>>>> On Thu, May 16, 2013 at 5:49 AM, Christian König
>>>>> <christian.koenig@amd.com> wrote:
>>>>>> Am 16.05.2013 11:41, schrieb Christian König:
>>>>>>
>>>>>> Ups, the board DOES have a serial port, and I've got a log now that
>>>>>> shows
>>>>>> the mentioned patch above isn't the root cause.
>>>>>>
>>>>>> After commit 8d57470d8f859635deffe3919d7d4867b488b85a it indeed crashes
>>>>>> very
>>>>>> early in the boot sequence, but commit
>>>>>> 98e7a989979b185f49e86ddaed2ad6890299d9f0 fixes that and now it crashes
>>>>>> while
>>>>>> trying to unpack the initrd with a completely different backtrace.
>>>>>>
>>>>> ok, did you post the boot log for that failing boot ?
>>>>
>>>> Yes, the bootlog is attached, but I also send it as "3.9 breaks EFI boot
>>>> on
>>>> E350 v2" to LKML with a request for help.
>>> can you boot with appending with "memtest"?
>>
>> Sure, bootlog with memtest is attached.
> Please check attached patch, it should fix the problem.

Works perfectly, thanks allot.

Christian.

> Thanks
>
> Yinghai


