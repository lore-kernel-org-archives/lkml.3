Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3FXQhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:37:32 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:59575 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FXQha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:37:30 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-87-51c875c9497b
From: Shuah Khan <shuah.kh@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Joe Perches <joe@perches.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Thread-topic: [PATCHv v3] power: Include additional information in
 pm_print_times
Thread-index: AQHOa5INUOX6+S75906ZF4yA9Bsfdg==
Date: Mon, 24 Jun 2013 16:37:28 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172F34D@sisaex02sj>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
 <3043483.hQyzHovghE@vostro.rjw.lan> <1371987257.3137.44.camel@joe-AO722>
 <7303551.DgZO2t6GUO@vostro.rjw.lan>
 <B8EFE96D1287C24090BAD9D858E15E6172F2E7@sisaex02sj>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9hX92TpScCDeZ90bVoXryezWL2/ccs
	FrOm7GWyuLxrDpvF594jjBZ3Tx1ls+hf2Mtk8fWngwOHx85Zd9k9Fu95yeSxf+4ado8vq64x
	ezxa3MLosWL1d3aPz5vkAtijuGxSUnMyy1KL9O0SuDI2np7HWnCPq2Lt5G72BsabHF2MnBwS
	AiYS+1afYYawxSQu3FvP1sXIxSEksIxRYuK30+wQTi+TxIXd56Cc+YwSLxqnsIO0sAmoS3x+
	vQPMFhFQlWi5+hisnVlgNrPEmisf2EASwgIBEv8nT2KBKAqWmPfrGyOErSexdvZqsBoWoOaN
	xx+BDeIVsJfY+/I91B2vGSUeXf8CdiAj0IHfT61hArGZBcQlmltvskAcLiCxZM95qCdEJV4+
	/sfaxcgBZCtKbF9tBVGuJbF+53GoVm2JJ+8usELsEpT4MfkeywRGsVlIps5C0jILScssJC0L
	GFlWMYqVFicXFCelp1YY6xUn5haX5qXrJefnbmKERGzNDsZ7X20OMQpwMCrx8H6IOxEoxJpY
	VlyZe4hRgoNZSYQ3VAQoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbFO/h2D2Iupj7xtSvb0195q
	n1+Q65sXf/2P6+JL/AEL5+sxtRzTiTh1TXodf1QFa9MtzYd69Rfm8rpuKby0YYoR07lbj+cF
	9rg3MpacSlUKaA/h5GSrDPh1eMJr/jKVE/+nPGI5Khg4++1Rj92f+dvYU93bpZUvd9zlq1Nx
	VtjJ8uT2T4uZSUosxRmJhlrMRcWJAMaDlwa2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 10:25 AM, Shuah Khan wrote:
> On 06/23/2013 03:49 PM, Rafael J. Wysocki wrote:
>> On Sunday, June 23, 2013 04:34:17 AM Joe Perches wrote:
>>> On Sun, 2013-06-23 at 13:36 +0200, Rafael J. Wysocki wrote:
>>>> Please keep the existing format as is literally and append any
>>>> new information to the end of the line.
>>>
>>> Hi Shuah.
>>>
>>> Perhaps the better long-term approach would be to add
>>> a new tracepoint too.
>>
>> In fact, I would even prefer it if new tracepoints were added so that we
>> could deprecate the dmesg messages at one point in the future.
>>
>> Thanks,
>> Rafael
>>
>>
>
> Rafael/Joe,
>
> I can work on adding a tracepoint. Do you want to take the v2 patch in
> the meantime?
>

Rafael,

ok. Caught up with the entire thread. v2 patch uses dev_info() and hence 
same concern about format change applies to that one as well.

Do you want to take the v1 patch that didn't change the format and just 
added the additional information at the end?

https://lkml.org/lkml/2013/6/14/330

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
