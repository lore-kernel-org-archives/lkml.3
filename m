Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3HATpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:45:42 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:60733 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3HATpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:45:38 -0400
X-Greylist: delayed 157369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Aug 2013 15:45:38 EDT
X-AuditID: cbfec37a-b7fc36d0000050de-b2-51fabae1c8ef
From: Shuah Khan <shuah.kh@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shuah Khan <shuahkhan@gmail.com>, linux-pci <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Myron Stowe <myron.stowe@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [Announcement] Linux Plumbers ACPI/PM, PCI Microconference
Thread-topic: [Announcement] Linux Plumbers ACPI/PM, PCI Microconference
Thread-index: AQHOjgvy8uNOkhFmeEaKNhY7jYdx5g==
Date: Thu, 01 Aug 2013 19:45:35 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617505EB@sisaex01sj>
References: <CAL-B5D03ki8NHsM6EuESTH2K-Eh+XyFHNXPDYwgDq+oagDjtMQ@mail.gmail.com>
 <1755363.sGc8nLIQOW@vostro.rjw.lan>
 <CAKocOOPOqqS80D23z6xTVSNYYYWZ7ACg9MtSMz_hTqVA3Duo0w@mail.gmail.com>
 <7183196.Ov6Qetq3lO@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9hX92Hu34FGvy9J2qxpCnDYsF+a4s5
	Uwstlu/rZ7TY9Pgaq8XlXXPYLM7OO85m8bn3CKPF+Z0LWC36F/YyWXz96WCx/Ow8Ngcej52z
	7rJ7LNhU6rF5Sb3H5BvLGT0eLW5h9Pi8SS6ALYrLJiU1J7MstUjfLoErY17HapaCi4IVH3//
	Y25gPMvXxcjBISFgIrF2sX8XIyeQKSZx4d56ti5GLg4hgWWMEnsOnGCCcHqZJI59nM0K4cxn
	lLh58iYbSAubgLrE59c72EFsEQFViS1P/rODFDELvGKRWHn9LwtIQljAXWJfdxNUkYfEsYur
	mCFsPYlJi5czgtgsQM2Xfvcxgdi8AvYS82Zvgtr2lFHi4JyXrCAJRqADv59aA1bELCAu0dx6
	kwXicAGJJXvOM0PYohIvH/9jhfhNUWL7aiuIci2J9TuPQ7VqSzx5d4EVYpegxI/J91gmMIrN
	QjJ1FpKWWUhaZiFpWcDIsopRrLQ4uaA4KT21wlCvODG3uDQvXS85P3cTIySGq3Yw3vlqc4hR
	gINRiYf3QeavQCHWxLLiytxDjBIczEoivH9mA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwOr09
	d6t82o2kF6LzVrkdWiGhy3biwG6tQ1q5ys9yTs81bUh/b/ji60WN9VnrzXjqcuPXV67e+8Dt
	eEVJga3GPl/uvZEvT1ca/DFtvz51berpAK+Jt7W4it/9vPjUQWF/n1ugfY8wu3hbOvtZiUDj
	1vZevW9Ff56uVXE+/8apZ+mLzxsuzONvVmIpzkg01GIuKk4EAC/S3l2/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 03:07 PM, Rafael J. Wysocki wrote:
> On Wednesday, July 31, 2013 10:35:05 AM Shuah Khan wrote:
>> On Wed, Jul 31, 2013 at 5:40 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> Hi All,
>>>
>>> The original announcement didn't go to linux-pm, so again:
>>>
>>> On Tuesday, July 16, 2013 08:21:26 PM Myron Stowe wrote:
>>>> Linux Plumbers has approved an ACPI/PM, PCI microconference. The
>>>> overview page is here:
>>>>
>>>> http://wiki.linuxplumbersconf.org/2013:pci_subsystem
>>>>
>>>> We would like to start receiving volunteers for presenting topics of
>>>> interest.  There is a lot of activity in these subsystems so please
>>>> respond by submitting presentation or discussion proposals that you
>>>> would be willing to cover for consideration.  You should also feel
>>>> free to submit ideas as proposals that others could cover.  The
>>>> instructions for submitting ideas should be at:
>>>>
>>>> http://www.linuxplumbersconf.org/2013/submitting-topic/
>>>
>>> If anyone who's going to attend the Linux Plumbers Conf this year is interested
>>> in any particular topic for discussion during the ACPI/PM+PCI uconf, please
>>> submit a formal topic proposal at:
>>>
>>> http://www.linuxplumbersconf.org/2013/ocw/events/LPC2013/proposals/new
>>>
>>> If you submit a topic, that doesn't mean you'll be expected to present anything
>>> (if accepted).  In fact, we are mostly interested in discussion topics and we'd
>>> like to know what is important to people.
>>>
>>> That said if you have a (short) presentation to make, please submit it too.
>>>
>>> We'll appreciate all submissions very much.
>>>
>>
>> What I have mind is a discussion topic for the Mini-conference, which
>> in-line with what you are asking for.
>> I will add it to the web.
>
> Thank you!

Rafael,

Done. I submitted a topic for discussion.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
