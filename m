Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3KFLQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:16:33 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:25285
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756416Ab3KFLQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:16:31 -0500
From: Peter Guo <peter.guo@bayhubtech.com>
To: Chris Ball <cjb@laptop.org>
CC: Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>,
        Adam Lee <adam.lee@canonical.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD
 Host
Thread-Topic: [PATCH v3] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD
 Host
Thread-Index: Ac7T0aLZ4wAqXCC0T9+Qz6KrYAh7zwHD9B8w
Date: Wed, 6 Nov 2013 11:16:20 +0000
Message-ID: <2b022a4239ee41c481e9e8fa427efa57@BN1PR04MB091.namprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(164054003)(199002)(189002)(377454003)(74706001)(87266001)(76576001)(81342001)(76482001)(77096001)(76786001)(76796001)(56816003)(81542001)(2656002)(74876001)(69226001)(49866001)(4396001)(47736001)(19580405001)(50986001)(83322001)(19580395003)(47976001)(33646001)(80976001)(81816001)(81686001)(46102001)(51856001)(53806001)(85306002)(31966008)(74662001)(74502001)(47446002)(74366001)(74316001)(83072001)(54316002)(56776001)(63696002)(59766001)(80022001)(77982001)(54356001)(66066001)(65816001)(76176001)(79102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR04MB375;H:BN1PR04MB091.namprd04.prod.outlook.com;CLIP:27.17.7.178;FPR:;RD:InfoNoRecords;A:0;MX:1;LANG:en;
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
Sent: Monday, October 28, 2013 7:34 PM
To: 'Chris Ball'; 'Adrian Hunter'; 'Greg Kroah-Hartman'; 'Bill Pemberton'; 'Guennadi Liakhovetski'; 'linux-mmc@vger.kernel.org'; 'linux-kernel@vger.kernel.org'
Cc: Samuel Guan; Xiaoguang Yu; Shirley Her; Yuxiang Wan; 'Adam Lee'
Subject: [PATCH v3] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD Host

Add O2Micro/BayHubTech SD Host DeviceId 8520 support.
Add O2Micro/BayHubTech SD Host DeviceId 8420 & 8421 support.
Add O2Micro/BayHubTech SD Host DeviceID 8620 & 8621 support.
Move O2Micro/BayHubTech SD Host support code to sdhci-pci-o2micro.c

Signed-off-by: peter.guo <peter.guo@bayhubtech.com>
---

