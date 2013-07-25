Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3GYXLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:11:22 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43826 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3GYXLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:11:20 -0400
X-AuditID: cbfec37b-b7f306d0000047de-ed-51f1b0960b5b
From: Shuah Khan <shuah.kh@samsung.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Varun.Sethi@freescale.com" <Varun.Sethi@freescale.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>, "joe@perches.com" <joe@perches.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "andreas.herrmann@calxeda.com" <andreas.herrmann@calxeda.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 0/4] iommu: Add event tracing feature to iommu
Thread-topic: [PATCH 0/4] iommu: Add event tracing feature to iommu
Thread-index: AQHOiTkS5thczE0zBk2/LnmZo1iUEA==
Date: Thu, 25 Jul 2013 23:11:16 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174A596@sisaex01sj>
References: <cover.1374711464.git.shuah.kh@samsung.com>
 <1374758841.3356.174.camel@gandalf.local.home>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9hX93pGz4GGtzZzmrRe7zI4tv/HjaL
	xUdiLGa+7mayWLDf2mL2/ccsFp2zN7BbXN41h83i0oEFTBa/V/9gttjX8YDJ4utPB4v9V7ws
	Zt5aw2Lx8uMJFgd+jycH5zF5rJm3htHj29dJLB4LPl9h9/h3uJ/JY+esu+weLftusXtMvrGc
	0ePG3WY2jy+rrjF7vN93lc3j8yY5j0+f9rEF8EZx2aSk5mSWpRbp2yVwZZw8dYil4D9XReeM
	OewNjE84uhg5OSQETCTmXz7MDmGLSVy4t56ti5GLQ0hgGaPEthlHwBJCAr1MEtPXqEIk5jNK
	7Hh6kQkkwSagLvH59Q6wIhEBDYmWBc9ZQIqYBa6zSlzaMRusSFjASeLlhyWMEEXOEnOvtzF3
	MXIA2XoSjS08IGEWAVWJ5fvPgZXwCthLTOxvYYNYnCHRfeUhmM0IdN33U2vARjILiEs0t95k
	gbhaQGLJnvPMELaoxMvH/1hBxksIKEpsX20FUa4lsX7ncahWbYkn7y6wQqwSlPgx+R7LBEax
	WUimzkLSMgtJyywkLQsYWVYxipUWJxcUJ6WnVhjpFSfmFpfmpesl5+duYoQkieodjHe/2hxi
	FOBgVOLhPWH/MVCINbGsuDL3EKMEB7OSCO+tXqAQb0piZVVqUX58UWlOavEhRiYOTqkGxnnp
	m9f13Tt/x5ZxubekL+cjNpF19W6zixeumjt7a+grldX/VbpOX1Cu1mNyn3iga87dpqir5mz/
	bW/Hb7/W9cnCY/9js6qvIn+3fRNa7Sl0fed00b9tl0xrqw7z++6eJJiwbC33it0Tn+7yiUqY
	ezFrsaYMK5dCTVy6+eaW+u/fMtYem8h0/qUSS3FGoqEWc1FxIgBqj/x08AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 07:27 AM, Steven Rostedt wrote:
> On Thu, 2013-07-25 at 07:15 -0600, Shuah Khan wrote:
>
>> Shuah Khan (4):
>>    iommu: Add event tracing feature to iommu - Add iommu trace events
>>    iommu: Add event tracing feature to iommu - export trace events
>>    iommu: Add event tracing feature to iommu - amd_iommu driver trace
>>      events
>>    iommu: Add event tracing feature to iommu - iommu driver trace events
>>
>>   drivers/iommu/Makefile       |    1 +
>>   drivers/iommu/amd_iommu.c    |   19 +++++
>>   drivers/iommu/iommu-traces.c |   27 +++++++
>>   drivers/iommu/iommu.c        |   17 ++++-
>>   include/trace/events/iommu.h |  174 ++++++++++++++++++++++++++++++++++++++++++
>>   5 files changed, 237 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/iommu/iommu-traces.c
>>   create mode 100644 include/trace/events/iommu.h
>
> I don't know what the maintainer thinks, but usually new tracepoints
> like this are done as one patch. Not four.
>
> -- Steve
>

If one single patch is preferred, I can easily generate one. Does the 
code look good otherwise?

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
