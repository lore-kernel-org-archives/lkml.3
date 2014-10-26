Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaJZMZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 08:25:31 -0400
Received: from mail-by2on0112.outbound.protection.outlook.com ([207.46.100.112]:20704
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbaJZMZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 08:25:30 -0400
X-WSS-ID: 0NE1X6D-08-9WF-02
X-M-MSG: 
From: "Skidanov, Alexey" <Alexey.Skidanov@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 32 bit user space compatibility
Thread-Topic: 32 bit user space compatibility
Thread-Index: Ac/xF9+cKUhXAvaXQgKq6+uAczaaCA==
Date: Sun, 26 Oct 2014 12:25:08 +0000
Message-ID: <AD975D71AAD7784D8D1265DF6444C2FD0C4307FC@storexdag03.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.0.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(50986999)(87936001)(21056001)(110136001)(54356999)(106466001)(107046002)(23726002)(229853001)(97756001)(120916001)(64706001)(31966008)(95666004)(105586002)(55846006)(2656002)(97736003)(101416001)(53416004)(107886001)(2351001)(80022003)(85852003)(92726001)(33656002)(50466002)(46102003)(68736004)(77096002)(99396003)(76482002)(44976005)(92566001)(84676001)(86362001)(46406003)(85306004)(47776003)(4396001)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0201MB1006;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1006;
X-Forefront-PRVS: 0376ECF4DD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Alexey.Skidanov@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running 32 bit user space needs some work to be done with ioctls. I understand that there are two options to implement:
1.       Use only fixed size types. Pad IOCTLS params to multiple of 64 bits - simple; don't know if it covers all compatibility issues; 
2.       32 bit compatibility layer (through compat_ioctl, just like many drivers in kernel implement)  - just a little bit simple code with some translations; really covers all issues;
 
Which one is preferred by kernel community?

Thanks
Alexey
