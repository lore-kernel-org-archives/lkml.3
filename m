Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab3GaACv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:02:51 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:55381 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3GaACu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:02:50 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-7d-51f85428a3c7
From: Shuah Khan <shuah.kh@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shuah Khan <shuahkhan@gmail.com>, Myron Stowe <myron.stowe@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: Linux Plumbers ACPI/PM, PCI Microconference
Thread-topic: Linux Plumbers ACPI/PM, PCI Microconference
Thread-index: AQHOgvpyC+NKOiAswk2bKGhMiOAClA==
Date: Wed, 31 Jul 2013 00:02:46 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174F0B5@sisaex01sj>
References: <CAL-B5D03ki8NHsM6EuESTH2K-Eh+XyFHNXPDYwgDq+oagDjtMQ@mail.gmail.com>
 <CAKocOOOgEb5h1dZWP_2UqBKhSK9U-kxKUbvTdzHfds=RiDzNJg@mail.gmail.com>
 <1476124.sWE2ygoo2D@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9hP12NkB+BBovOalss2G9tMWdqocXy
	ff2MFpseX2O1uLxrDpvF2XnH2SzO71zAatG/sJfJ4utPB4vlZ+exOXB57Jx1l91j85J6j8k3
	ljN6PFrcwujxeZNcAGsUl01Kak5mWWqRvl0CV8bLM3vZC/5wVPxaeIuxgXEmexcjJ4eEgInE
	t1/nmCFsMYkL99azdTFycQgJLGOU+DznPhOE08sk8WnLXqjMfEaJf78+MoG0sAmoS3x+vQNs
	lIiAqsSWJ//ZQYqYBeazSJzaNwOsSFjAQmLO8ecsXYwcQEWWEnN3B0LU60k0Hz/CAmKzAPUe
	WniVFcTmFbCXWPdvNdTm/YwS8z4cAVvACHTf91NrwGYyC4hLNLfeZIG4W0BiyZ7zUD+ISrx8
	/I8VZJeEgKLE9tVWEOVaEut3Hodq1ZZ48u4C1C5BiR+T77FMYBSbhWTqLCQts5C0zELSsoCR
	ZRWjWGlxckFxUnpqhbFecWJucWleul5yfu4mRkik1uxgvPfV5hCjAAejEg+v44XvgUKsiWXF
	lbmHGCU4mJVEeOWDfgQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYMwyXrb6+rK42MvF5e84c35c
	PbB9v2WC06aZIU+qJde7GB57GOko8PjcQ47Xzbq8f5f1hnW9aFrWvP/W+hcmHM8kz/VpCTdF
	8U4OYP97MO54v/eqFGkdj6gas8/3ta5/mHkhV+Yu77olTG/23+tLzXBZlm2qEPLb32i1mYbX
	KeNlG5amXn946p0SS3FGoqEWc1FxIgD3Aj70sgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 05:38 PM, Rafael J. Wysocki wrote:
> On Wednesday, July 17, 2013 08:31:55 AM Shuah Khan wrote:
>> Myron,
>>
>> On Tue, Jul 16, 2013 at 8:21 PM, Myron Stowe <myron.stowe@gmail.com> wrote:
>>
>>>
>>> Shuah - You brought up the idea about "Converting drivers from Legacy
>>> PM ops to dev_pm_ops"; would you like to present what you have
>>> done/encountered so far?
>>>
>>
>> Awesome. Yes, I would like to present what I have done so far and I do
>> have a couple of things that could benefit from a face to face
>> discussion which would help me make progress on the rest of the work
>> that needs to get done.
>
> Care to sumbit a formal proposal through the LPC web page?
>
> Rafael
>
>

Rafael,

I did submit a formal talk proposal to LinuxCon/LPC and it was rejected. 
Submission is closed now as far as I know.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
