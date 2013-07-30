Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3G3BY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:24:56 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:21952 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3G3BYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:24:54 -0400
X-AuditID: cbfec37d-b7f036d000004805-62-51f715e5b126
From: Shuah Khan <shuah.kh@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Varun.Sethi@freescale.com" <Varun.Sethi@freescale.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>, "joe@perches.com" <joe@perches.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "andreas.herrmann@calxeda.com" <andreas.herrmann@calxeda.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] iommu: Add event tracing feature to iommu
Thread-topic: [PATCH v2] iommu: Add event tracing feature to iommu
Thread-index: AQHOjMNeamWGzGXnqUif254kO+fg8A==
Date: Tue, 30 Jul 2013 01:24:51 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174E3EE@sisaex01sj>
References: <1375147366-2922-1-git-send-email-shuah.kh@samsung.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9hP92not8DDS41yVv0Hi+y+Pa/h81i
	8ZEYi5mvu5ksFuy3tph9/zGLRefsDewWl3fNYbO4dGABk8Xv1T+YLfZ1PGCy+PrTwWL/FS+L
	mbfWsFi8/HiCxYHf48nBeUwea+atYfT49nUSi8eCz1fYPf4d7mfy2DnrLrtHy75b7B6Tbyxn
	9Lhxt5nN48uqa8we7/ddZfP4vEnO49OnfWwBvFFcNimpOZllqUX6dglcGbsOn2IsWMlUcfHA
	KfYGxh+MXYycHBICJhKHp01hgrDFJC7cW8/WxcjFISSwjFFi9b0uFginl0li7faf7BDOfEaJ
	ZRN3gbWwCahLfH69gx3EFhFQlWi5+hisnVngMatEz4cbzF2MHBzCAo4SMy85QNQ4Scx5O5cZ
	wtaTuDXtEAuIzQLU2/53NhuIzStgL7Fn63GwmUICzhKXn64Fq2cEOu/7qTVge5kFxCWaW2+y
	QJwtILFkz3lmCFtU4uXjf6wgayUEFCW2r7aCKNeSWL/zOFSrtsSTdxdYIVYJSvyYfI9lAqPY
	LCRTZyFpmYWkZRaSlgWMLKsYxUqLkwuKk9JTK0z0ihNzi0vz0vWS83M3MULSRO0OxvtfbQ4x
	CnAwKvHwRuR9CxRiTSwrrsw9xCjBwawkwstyAyjEm5JYWZValB9fVJqTWnyIkYmDU6qBce7X
	q2YHz26KjC/7eWHj66pdAVULr6luF0ri3LVwvt5F2dLjb092ZdeErfzyUju8rmKu0c9fxmen
	NJ8UZue4VKDvcnqxutVJ4Xufrusxz0nNKFI6LeGy8PCl/LtWocoLS/++6NNhNlwk5zY/I2Ce
	2LKOA2vvb/LkK3+0sjPb6UHSNdV1XHYKfEosxRmJhlrMRcWJANMPFS3xAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 07:23 PM, Shuah Khan wrote:

Sorry please ignore this patch. I accidentally included test code.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
