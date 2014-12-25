Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaLYDWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 22:22:55 -0500
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:18656
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637AbaLYDWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 22:22:53 -0500
Date: Thu, 25 Dec 2014 10:13:57 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: Stefan Agner <stefan@agner.ch>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: chipidea: Add identification registers access
 APIs
Message-ID: <20141225021355.GB5077@shlinux2>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
 <72124df17c0f40f8a7ae02faa9664b9d51743584.1418981438.git.maitysanchayan@gmail.com>
 <4f5efe169ed3ab16ffcbee52dd6b7661@agner.ch> <549AE6A3.3060009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <549AE6A3.3060009@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(377454003)(51704005)(377424004)(199003)(479174004)(24454002)(43544003)(189002)(97736003)(46406003)(50466002)(92566001)(83506001)(33716001)(62966003)(77156002)(120916001)(106466001)(87936001)(21056001)(99396003)(23726002)(85426001)(31966008)(77096005)(47776003)(20776003)(64706001)(93886004)(54356999)(97756001)(50986999)(76176999)(86362001)(104016003)(84676001)(105606002)(2950100001)(107046002)(68736005)(33656002)(6806004)(110136001)(46102003)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0626;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0626;
X-Forefront-PRVS: 04362AC73B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2014 03:22:49.7293
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0626
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 09:45:31PM +0530, Sanchayan Maity wrote:
> On 12/24/2014 09:30 PM, Stefan Agner wrote:
> > On 2014-12-19 10:55, Sanchayan Maity wrote:
> >> Using hw_write_id_reg and hw_read_id_reg to write and read
> >> identification registers contents. This can be used to get
> >> controller information, change some system configurations
> >> and so on.
> > 
> > Checkpatch is complaining about DOS line endings and some trailing
> > whitespace. This applies to all three patches.
> 
> Hmm... that's surprising. I did run checkpatch at my end before sending.
> I do not have the original patchset on my laptop which I have right now
> but downloading diffs back from lkml and running checkpatch on them back,
> only gives me signed off errors as it should. 
> 
> I will resend if somehow errors crept in with my earlier patches.
> 
> -Sanchayan
> 

Hi Sanchayan,

I will take care the first two, you are the third if there is any
comments, thanks.

-- 

Best Regards,
Peter Chen
