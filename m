Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaHKQWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:22:24 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:43234
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754290AbaHKQWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:22:23 -0400
Message-ID: <53E8EDAB.7000807@licor.com>
Date: Mon, 11 Aug 2014 11:22:03 -0500
From: Darryl <ddegraff@licor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: OMAP3/AM3517 EHCI USB Issue
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [157.56.232.165]
X-ClientProxiedBy: BN1PR08CA0047.namprd08.prod.outlook.com (10.242.217.175) To
 SN2PR0801MB0768.namprd08.prod.outlook.com (25.160.58.143)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03008837BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199002)(189002)(54356999)(101416001)(99396002)(87266999)(47776003)(83072002)(92566001)(107886001)(4396001)(66066001)(80316001)(106356001)(65956001)(83322001)(42186005)(50986999)(50466002)(33656002)(85852003)(80022001)(102836001)(87976001)(83506001)(21056001)(77096002)(64706001)(20776003)(92726001)(105586002)(95666004)(23676002)(81542001)(85306004)(81342001)(74502001)(31966008)(74662001)(36756003)(77982001)(107046002)(46102001)(79102001)(76482001)(64126003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR0801MB0768;H:BLUPRD0810HT001.namprd08.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: licor.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of folks had discussed this issue.  I have a similar problem on 
3.13.2. Wondering if there is any progress.

One issue that we noticed, in reviewing the 2.6.32 kernel + patches from 
LogicPD, was that the phy was not taken out of reset, but even this did 
push us forward.


Please mail me directly as I am not subscribed.
