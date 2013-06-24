Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3FXQZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:25:30 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:59020 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3FXQZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:25:28 -0400
X-AuditID: cbfec37d-b7f036d000004805-71-51c872f703a9
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
Date: Mon, 24 Jun 2013 16:25:26 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172F2E7@sisaex02sj>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
 <3043483.hQyzHovghE@vostro.rjw.lan> <1371987257.3137.44.camel@joe-AO722>
 <7303551.DgZO2t6GUO@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9hX93vRScCDe7d07ZoXryezWL2/ccs
	FrOm7GWyuLxrDpvF594jjBZ3Tx1ls+hf2Mtk8fWngwOHx85Zd9k9Fu95yeSxf+4ado8vq64x
	ezxa3MLosWL1d3aPz5vkAtijuGxSUnMyy1KL9O0SuDIO/+YuWM1ecfrDG9YGxq+sXYwcHBIC
	JhJ9n2K6GDmBTDGJC/fWs3UxcnEICSxjlLjy4BAThNPLJPHk3SmozHxGiUP7XzODtLAJqEt8
	fr2DHcQWEVCV2PLkPztIEbPADyaJnYf3MYIkhAUCJP5PnsQCURQsMe/XN0YIW09i7ezVbCA2
	C1Dzir6tTCA2r4C9xMt726G2bWWU2Nl8FyzBCHTg91NrwGxmAXGJ5tabLBCHC0gs2XOeGcIW
	lXj5+B/Ub4oS21dbQZRrSazfeRyqVRvomwusELsEJX5MvscygVFsFpKps5C0zELSMgtJywJG
	llWMYqXFyQXFSempFSZ6xYm5xaV56XrJ+bmbGCHRWruD8f5Xm0OMAhyMSjy8M2JOBAqxJpYV
	V+YeYpTgYFYS4Q0VAQrxpiRWVqUW5ccXleakFh9iZOLglGpg7Mk8wKLMaReqenEpg1p1wsyd
	6xfFzvTXu8h89LP7xjWxLVtnvLj2RoI9qio0fHOx06S9jb1fDNZvTnL5Mm2a3+aIdXu45isI
	C1SomD39O89na9Xs4oBdc5udk5fuLJl4NrFp+jSxmX2z/rC+rqpLerCn2uom73Yv/k7ftsS+
	/uq5rZZs2jLJSizFGYmGWsxFxYkAjGH6TLQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 03:49 PM, Rafael J. Wysocki wrote:
> On Sunday, June 23, 2013 04:34:17 AM Joe Perches wrote:
>> On Sun, 2013-06-23 at 13:36 +0200, Rafael J. Wysocki wrote:
>>> Please keep the existing format as is literally and append any
>>> new information to the end of the line.
>>
>> Hi Shuah.
>>
>> Perhaps the better long-term approach would be to add
>> a new tracepoint too.
>
> In fact, I would even prefer it if new tracepoints were added so that we
> could deprecate the dmesg messages at one point in the future.
>
> Thanks,
> Rafael
>
>

Rafael/Joe,

I can work on adding a tracepoint. Do you want to take the v2 patch in 
the meantime?

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
