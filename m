Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaFCHQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:16:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50512 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315AbaFCHQG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:16:06 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: "tj@kernel.org" <tj@kernel.org>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "todd.e.brandt@intel.com" <todd.e.brandt@intel.com>,
        "lukasz.dorau@intel.com" <lukasz.dorau@intel.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Tue, 3 Jun 2014 00:13:59 -0700
Subject: RE: [PATCH 1/3] libsas: modify SATA error handler
Thread-Topic: [PATCH 1/3] libsas: modify SATA error handler
Thread-Index: Ac9gIz+6NlMHP0+VRGeWpo+8sjBniQe17S8g
Message-ID: <F766E4F80769BD478052FB6533FA745D57320C6287@SC-VEXCH4.marvell.com>
References: <1398346047-10276-1-git-send-email-yxlraid@gmail.com>
 <CAP0P+NWxxxnQH1e3tXcqwud7EaV4kRRMW46Ad-PWoMWFzgy1eg@mail.gmail.com>
In-Reply-To: <CAP0P+NWxxxnQH1e3tXcqwud7EaV4kRRMW46Ad-PWoMWFzgy1eg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_02:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406030092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How about the patch?


>From: Xiangliang Yu <yxlraid@gmail.com>
>Date: 2014-04-24 21:27 GMT+08:00
>Subject: [PATCH 1/3] libsas: modify SATA error handler
>To: tj@kernel.org, JBottomley@parallels.com
>Cc: dan.j.williams@intel.com, todd.e.brandt@intel.com, >lukasz.dorau@intel.com, linux-ide@vger.kernel.org, linux->kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiangliang Yu ><yxlraid@gmail.com>
>
>Add support for SATA port softreset and port multiplier error
>handling.
>
>Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
---
 
