Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966600Ab3HHVCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:02:05 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:50184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966576Ab3HHVCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:02:04 -0400
X-Greylist: delayed 921 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 17:02:03 EDT
Date: Thu, 8 Aug 2013 16:49:27 -0400
From: Philip R Auld <pauld@egenera.com>
To: <linux-kernel@vger.kernel.org>
CC: <pauld@egenera.com>
Subject: 3.11.0-rc4 wireless and networkmanager stopped working
Message-ID: <20130808204927.GB25383@annuminas.egenera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [209.92.242.194]
X-ClientProxiedBy: CO1PR06CA007.namprd06.prod.outlook.com (10.242.160.17) To
 BLUPR07MB116.namprd07.prod.outlook.com (10.242.200.16)
X-Forefront-PRVS: 093290AD39
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(164054003)(199002)(189002)(33656001)(83072001)(46406003)(65816001)(47446002)(52956002)(81542001)(23726002)(47736001)(81686001)(51856001)(76786001)(80022001)(46386002)(16406001)(66066001)(83322001)(50986001)(49866001)(74876001)(69226001)(42186004)(54356001)(76482001)(47976001)(4396001)(53806001)(74706001)(45336002)(77982001)(74366001)(59766001)(79102001)(81342001)(46102001)(76796001)(74502001)(63696002)(47776003)(31966008)(50466002)(76176001)(74662001)(56776001)(56816003)(80976001)(77096001)(54316002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB116;H:annuminas.egenera.com;CLIP:209.92.242.194;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: egenera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

    Wireless networking on my opensuse 12.3 system has been changing in recent
kernels. Initially, I used an ifup style setup. That stopped worked around 3.5
or 3.6. When that happened I switched to networkmanager and it worked... for
a while.

That stopped working as well at, I think, 3.8 (I did not use 3.7). 
At that point I reverted to the vendor kernel. 

At 3.11.0-rc3 I udpated my tree and built it again - same .config (modulo
changes for new entries) and lo and behold wifi started working.

Today I updated to 3.11.0-rc4 and again built with the same basic .config
and it's back to where it was before. 

Something between rc3 and rc4 re-breaks networkmanager. 

Fwiw, the symptom is a failure to get an IP. It claims to find the 
base station and iwconfig output looks reasonable. The DHCP never 
completes.

Fwiw it's an iwl3945.

Just switching back and forth between rc3 and rc4 makes it work or not.
No other changes. 



Thanks,


Phil
