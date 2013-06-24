Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3FXUic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:38:32 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54373 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3FXUib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:38:31 -0400
X-AuditID: cbfec37b-b7f306d0000047de-d5-51c8ae443969
From: Shuah Khan <shuah.kh@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joe Perches <joe@perches.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
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
Date: Mon, 24 Jun 2013 20:38:27 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172F8DF@sisaex02sj>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
 <B8EFE96D1287C24090BAD9D858E15E6172F2E7@sisaex02sj>
 <B8EFE96D1287C24090BAD9D858E15E6172F34D@sisaex02sj>
 <3098328.kly7qFelcA@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9hX13XdScCDR4eZrFoXryezWL2/ccs
	FrOm7GWyuLxrDpvF594jjBZ3Tx1ls+hf2Mtk8fWngwOHx85Zd9k9Fu95yeSxf+4ado8vq64x
	ezxa3MLosWL1d3aPz5vkAtijuGxSUnMyy1KL9O0SuDJO9TcxF1znrWhqX8vcwNjG3cXIySEh
	YCLx8nonC4QtJnHh3nq2LkYuDiGBZYwSJ0/fZ4Vwepkkune/h3LmM0psurqaEaSFTUBd4vPr
	HewgtoiAqsSWJ//ZQYqYBX4wSew8vA+sSFggQOL/5EksEEXBEvN+fWOEsPUk1s5eDbSPg4MF
	qHldgyJImFfAXmL7iWaoM64xSux+OA2slxHovu+n1jCB2MwC4hLNrTeh7haQWLLnPDOELSrx
	8vE/VpCZEgKKEttXW0GUa0ms33kcqlVb4sm7C6wQuwQlfky+xzKBUWwWkqmzkLTMQtIyC0nL
	AkaWVYxipcXJBcVJ6akVRnrFibnFpXnpesn5uZsYIfFavYPx7lebQ4wCHIxKPLwf4k4ECrEm
	lhVX5h5ilOBgVhLhDRUBCvGmJFZWpRblxxeV5qQWH2Jk4uCUamCc+a1u3pKjDy4lhBfFql+u
	vSsy7TzPP59P3lti0jiOhT4x2DM14fXZ0od5gTdKz+7t6Z0Rnniwc+N6tytJ/M7lT3R6LvvX
	WW9VczLWLz0va9pgf4ytwqD/n0vp1FLz6S4sXTGT7EVauA6rJHgtWMouy/6ET2buo1d3k3aZ
	3ZfxUGJhe1DqqafEUpyRaKjFXFScCAA7Ow5OtQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 01:35 PM, Rafael J. Wysocki wrote:
> On Monday, June 24, 2013 04:37:28 PM Shuah Khan wrote:
>> On 06/24/2013 10:25 AM, Shuah Khan wrote:
>>> On 06/23/2013 03:49 PM, Rafael J. Wysocki wrote:
>>>> On Sunday, June 23, 2013 04:34:17 AM Joe Perches wrote:
>>>>> On Sun, 2013-06-23 at 13:36 +0200, Rafael J. Wysocki wrote:
>>>>>> Please keep the existing format as is literally and append any
>>>>>> new information to the end of the line.
>>>>>
>>>>> Hi Shuah.
>>>>>
>>>>> Perhaps the better long-term approach would be to add
>>>>> a new tracepoint too.
>>>>
>>>> In fact, I would even prefer it if new tracepoints were added so that we
>>>> could deprecate the dmesg messages at one point in the future.
>>>>
>>>> Thanks,
>>>> Rafael
>>>>
>>>>
>>>
>>> Rafael/Joe,
>>>
>>> I can work on adding a tracepoint. Do you want to take the v2 patch in
>>> the meantime?
>>>
>>
>> Rafael,
>>
>> ok. Caught up with the entire thread. v2 patch uses dev_info() and hence
>> same concern about format change applies to that one as well.
>>
>> Do you want to take the v1 patch that didn't change the format and just
>> added the additional information at the end?
>
> Well, if you're going to work on the tracepoints, I'll rather not take this
> at all.
>
> Thanks,
> Rafael
>
>

Makes sense. Yes I am going to start work on tracepoints then.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
