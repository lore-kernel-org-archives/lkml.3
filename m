Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab3GVWYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:24:23 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:49542 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3GVWYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:24:22 -0400
X-AuditID: cbfec37d-b7f036d000004805-cf-51edb1145ca9
From: Shuah Khan <shuah.kh@samsung.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Konstantin Khlebnikov (khlebnikov@openvz.org)" 
	<khlebnikov@openvz.org>,
        "'arnd@arndb.de'" <arnd@arndb.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-topic: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-index: AQHOgudK0Ej0F1tjp0OVOBJnDTbTCg==
Date: Mon, 22 Jul 2013 22:24:18 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61747C35@sisaex01sj>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B028EBE55@HASMSX106.ger.corp.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE65788@HASMSX106.ger.corp.intel.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9hP12RjW8DDTrW6lj8nXSM3aJ58Xo2
	i/O3PjNbXN41h83i608Hiw89dQ5sHr9/TWL02DnrLrvH4j0vmTz2z13D7jHp8Gcmj8+b5ALY
	orhsUlJzMstSi/TtErgyrl9pZStYzlJxuuEbSwPjfuYuRk4OCQETiWt7l7ND2GISF+6tZ+ti
	5OIQEljGKHHy71YmkISQQC+TxL1eVYjEfEaJJ/17wTrYBNQlPr/eAWaLCOhJ3Fo9hx2kiFng
	CJPE9BWX2EASwgIOElMv7GOCKHKUWPL5PNBqDoiGZekgYRYBVYmDf44zgti8AvYSNy8eZYFY
	dptR4sOMm2BzGIHO+35qDdgcZgFxiebWmywQZwtILNlzHuodUYmXj/+xgsyXEFCU2L7aCqJc
	S2L9zuNQrdoST95dYIXYJSjxY/I9lgmMYrOQTJ2FpGUWkpZZSFoWMLKsYhQrLU4uKE5KT60w
	0StOzC0uzUvXS87P3cQIicbaHYz3v9ocYhTgYFTi4V3g+zZQiDWxrLgy9xCjBAezkgjvRj2g
	EG9KYmVValF+fFFpTmrxIUYmDk6pBkbVDUFqCwIYPU2eb2jpCTGIk17X+ljsMqPbN/Hzc6K3
	xmVf0nDjq/FlYVXdnB6VlLgh3O3DcUHOgBrfxf/7ehiFlJljnzNeilR4VNBSFe314+iHabfk
	5634priz6NcbKW/DNkHLkjOLrynf49j6yGWG6ZqYiQmnl6Y5S948/Pz4q8rSx16KyUosxRmJ
	hlrMRcWJAJZJuZWkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 03:36 PM, Winkler, Tomas wrote:
>>
>>
>>>
>>> This series should fix the long standing reset storm issue in mei
>>> suspend/resume failure
>>>
>
> Can you guys confirm these fixes the issue for you.
> Thanks
> Tomas

Yes. I am getting started with testing. Will let you know in a bit.

-- Shuah


-- 
Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
