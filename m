Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3GWBSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:18:05 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:37699 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3GWBSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:18:02 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-b1-51edd9c82005
From: Shuah Khan <shuah.kh@samsung.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "Konstantin Khlebnikov (khlebnikov@openvz.org)" 
	<khlebnikov@openvz.org>,
        "'arnd@arndb.de'" <arnd@arndb.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-topic: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-index: AQHOgudK0Ej0F1tjp0OVOBJnDTbTCg==
Date: Tue, 23 Jul 2013 01:17:58 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61747D6D@sisaex01sj>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B028EBE55@HASMSX106.ger.corp.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE65788@HASMSX106.ger.corp.intel.com>
 <B8EFE96D1287C24090BAD9D858E15E61747C35@sisaex01sj>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9hX90TN98GGjz9wWvxd9IxdovmxevZ
	LM7f+sxscXnXHDaLrz8dLD701Dmwefz+NYnRY+esu+wei/e8ZPLYP3cNu8ekw5+ZPD5vkgtg
	i+KySUnNySxLLdK3S+DKWPziMHPBF9aKJ6fXsjYwPmfpYuTgkBAwkbhy3beLkRPIFJO4cG89
	WxcjF4eQwDJGib7r91khnF4midsnlrFAOPMZJRb/+ssE0sImoC7x+fUOdhBbREBP4tbqOewg
	RcwCx5gkunt/s4IkhAUcJKZe2McEUeQoseTzeWaQ1WANy9JBwiwCqhIHOncwgoR5BewlPs4z
	gdg1kUni9NmZjCA1jEDnfT+1BmwMs4C4RHPrTRaIswUkluwBGQlii0q8fPyPFeIzRYntq60g
	yrUk1u88DtWqLfHk3QWwy3gFBCV+TL7HMoFRbBaSqbOQtMxC0jILScsCRpZVjGKlxckFxUnp
	qRXGesWJucWleel6yfm5mxghsVizg/HeV5tDjAIcjEo8vAt83wYKsSaWFVfmHmKU4GBWEuH9
	eAMoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTFB4sL7HQVP9kbPaZ3mVLJBt4k/qPP5YkUllp93
	7/N6Sot1l/bL7/i559LGhGuy7g0q6f2Slbd08zMO3fwZf7BwnYTW8u6bn63t9RYHLZNpuRp7
	68jl+Ie6txeazOOs2Nih37a1ePkv8yeMqqVf77zdaPJPof/I12ePWI6stGTL2/Oxrpz1kpAS
	S3FGoqEWc1FxIgAyC3i2owIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 04:24 PM, Shuah Khan wrote:
> On 07/22/2013 03:36 PM, Winkler, Tomas wrote:
>>>
>>>
>>>>
>>>> This series should fix the long standing reset storm issue in mei
>>>> suspend/resume failure
>>>>
>>
>> Can you guys confirm these fixes the issue for you.
>> Thanks
>> Tomas
>
> Yes. I am getting started with testing. Will let you know in a bit.
>
> -- Shuah
>
>

Did several suspend to disk tests (reboot, platform, and suspend) and 
didn't see the mei reset problem.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
