Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaIPPVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:21:01 -0400
Received: from mail-bl2on0134.outbound.protection.outlook.com ([65.55.169.134]:21056
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754467AbaIPPU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:20:59 -0400
X-WSS-ID: 0NC02MT-07-M2Q-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <linux@roeck-us.net>,
        <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: <boris.ostrovsky@oracle.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 0/2] Updates to fam15h_power driver
Date: Tue, 16 Sep 2014 10:38:27 -0500
Message-ID: <1410881907-1352-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(50466002)(87286001)(15202345003)(92566001)(15975445006)(53416004)(77156001)(229853001)(50226001)(83072002)(104166001)(4396001)(106466001)(64706001)(84676001)(90102001)(2201001)(107046002)(101416001)(81542003)(46102003)(74662003)(77982003)(74502003)(79102003)(62966002)(81342003)(80022003)(76482001)(95666004)(97736003)(68736004)(20776003)(85306004)(87936001)(44976005)(50986999)(47776003)(88136002)(86362001)(89996001)(77096002)(19580395003)(48376002)(99396002)(15395725005)(93916002)(21056001)(105586002)(85852003)(36756003)(31966008)(83322001)(92726001)(102836001)(2101003)(129325001)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR02MB483;H:atltwp01.amd.com;FPR:;MLV:nov;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches are based on Guenter's suggestion here:
http://marc.info/?l=linux-kernel&m=141038145616437&w=2

[Patch 1/2] is a bug fix.
 - We want to make actual power reporting conditional since power1_input
   is to be reported only on Fam15h, Models 00h-0fh
[Patch 2/2] is functionality extension.
 - Add PCI IDs for Fam16h,M30h(Mullins) and Fam15hM30h(Kaveri)
   to report power1_crit values

Aravind Gopalakrishnan (2):
  hwmon, fam15h_power: Make actual power reporting conditional
  hwmon, fam15h_power: Add support for two more processors

 drivers/hwmon/fam15h_power.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

-- 
2.0.2

