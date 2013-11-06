Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3KFLOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:14:35 -0500
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:49911
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab3KFLOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:14:34 -0500
From: Peter Guo <peter.guo@bayhubtech.com>
To: Chris Ball <cjb@laptop.org>
CC: Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>,
        Adam Lee <adam.lee@canonical.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mmc:sdhci fix 2 tuning issues in sdchi_exectuing_tuning
Thread-Topic: [PATCH] mmc:sdhci fix 2 tuning issues in sdchi_exectuing_tuning
Thread-Index: AQHO2uFc76VF4tmCckG+4/xSxQZYYQ==
Date: Wed, 6 Nov 2013 11:14:30 +0000
Message-ID: <ddebee7a9b284b968a8a10f7cb2bc3c6@BN1PR04MB091.namprd04.prod.outlook.com>
References: <97254cf7c23548fdbb3ebc10170af6a8@BL2PR04MB083.namprd04.prod.outlook.com>
 <20131016081532.GB3416@adam-laptop>  
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(199002)(189002)(164054003)(377454003)(65816001)(87266001)(2656002)(59766001)(76482001)(66066001)(79102001)(33646001)(56776001)(54316002)(63696002)(53806001)(54356001)(51856001)(46102001)(19580405001)(83322001)(4396001)(49866001)(81542001)(47736001)(47976001)(50986001)(19580395003)(83072001)(74706001)(76796001)(85306002)(74366001)(74876001)(81342001)(80976001)(47446002)(74662001)(77982001)(74502001)(80022001)(31966008)(77096001)(76576001)(76786001)(81816001)(81686001)(56816003)(74316001)(69226001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR04MB236;H:BN1PR04MB091.namprd04.prod.outlook.com;CLIP:27.17.7.178;FPR:;RD:InfoNoRecords;A:0;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: bayhubtech.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Do you have any comments on this patch?

Thanks,
Peter.Guo

-----Original Message-----
From: Peter Guo 
Sent: Tuesday, October 29, 2013 6:55 PM
To: 'Chris Ball'; 'linux-mmc@vger.kernel.org'; 'linux-kernel@vger.kernel.org'
Cc: Samuel Guan; Xiaoguang Yu; Shirley Her; Yuxiang Wan; 'Adam Lee'
Subject: [PATCH] mmc:sdhci fix 2 tuning issues in sdchi_exectuing_tuning


1. Tuning success at 40th time should be ok, but current code take this as
   failed.
2. tuning_count equals to 0 means disable retuning function, but current
   code still do retuning.

Signed-off-by: peter.guo <peter.guo@bayhubtech.com>
---

