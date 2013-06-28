Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3F1Row (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:44:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10763 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476Ab3F1Rov convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:44:51 -0400
From: Dan Williams <djbw@fb.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>
Subject: Re: dmaengine_unmap_data patches (was: Re: Re: [PATCH 02/12]
 dmaengine: prepare for generic 'unmap' data)
Thread-Topic: dmaengine_unmap_data patches (was: Re: Re: [PATCH 02/12]
 dmaengine: prepare for generic 'unmap' data)
Thread-Index: AQHOclovJLAhyFm5OUGCHqpjW159nJlLZymA
Date: Fri, 28 Jun 2013 17:35:52 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49172670C3@PRN-MBX01-3.TheFacebook.com>
In-Reply-To: <8491118.DYtx7SOBet@amdc1032>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.4.130416
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C392EEDA09173D46921500238E7EEAFF@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-28_08:2013-06-28,2013-06-28,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/26/13 3:44 AM, "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>
wrote:

>
>Hi,
>
>The original discussion is here:
>
>	https://lkml.org/lkml/2012/12/6/71
>
>Unfortunately there hasn't been any progress on these patches since
>last December.

Apologies, indeed these have languished.  I don¹t expect to have them
polished and tested in time for the upcoming merge window, but let¹s get
these in shape for 3.12.  I¹ll circle back in a few weeks unless you beat
me to it.

--
Dan

