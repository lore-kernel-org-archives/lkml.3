Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbbAHWA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:00:26 -0500
Received: from mail-bn1bon0141.outbound.protection.outlook.com ([157.56.111.141]:47573
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752017AbbAHWAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:00:24 -0500
X-WSS-ID: 0NHVP4I-07-XMT-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: RE: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm
 by default on BTC
Thread-Topic: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm
 by default on BTC
Thread-Index: AQHQKsyDkXQZKaorv0C9Tt5ssWsoXZy1RGNQgAF5YQD//6yOUIAAsFkA//+sk+A=
Date: Thu, 8 Jan 2015 22:00:16 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D0635E4C92@satlexdag05.amd.com>
References: <54ADB86B.10105@canonical.com>
 <A3397C8B8B789E45844E7EC5DEAD89D0635DD4D6@satlexdag06.amd.com>
 <54AEAF92.10507@canonical.com>
 <A3397C8B8B789E45844E7EC5DEAD89D0635E2A10@satlexdag05.amd.com>
 <54AEFD80.5090808@canonical.com>
In-Reply-To: <54AEFD80.5090808@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Alexander.Deucher@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(479174004)(377454003)(199003)(189002)(164054003)(24454002)(13464003)(21056001)(575784001)(120916001)(110136001)(99396003)(92566001)(86362001)(4396001)(33656002)(53416004)(55846006)(101416001)(2950100001)(15395725005)(23676002)(31966008)(64706001)(20776003)(47776003)(15198665003)(84676001)(50466002)(106116001)(105586002)(106466001)(1720100001)(107046002)(62966003)(77156002)(102836002)(54356999)(68736005)(2900100001)(87936001)(97736003)(19580395003)(19580405001)(76176999)(93886004)(2656002)(46102003)(15975445007)(2920100001)(50986999)(10090945008);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB206;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 22:00:20.3105
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t08M0V4w000992

> -----Original Message-----
> From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com]
> Sent: Thursday, January 08, 2015 4:58 PM
> To: Deucher, Alexander
> Cc: stable@vger.kernel.org; LKML; Koenig, Christian; David Airlie; dri-devel
> Subject: Re: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm
> by default on BTC
> 
> On 01/08/2015 12:48 PM, Deucher, Alexander wrote:
> >> -----Original Message-----
> >> From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com]
> >> Sent: Thursday, January 08, 2015 11:26 AM
> >> To: Deucher, Alexander
> >> Cc: stable@vger.kernel.org; LKML; Koenig, Christian; David Airlie; dri-devel
> >> Subject: Re: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable
> dpm
> >> by default on BTC
> >>
> >> On 01/07/2015 09:51 PM, Deucher, Alexander wrote:
> >>>> -----Original Message-----
> >>>> From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com]
> >>>> Sent: Wednesday, January 07, 2015 5:51 PM
> >>>> To: Deucher, Alexander
> >>>> Cc: stable@vger.kernel.org; LKML; Koenig, Christian; David Airlie; dri-
> devel
> >>>> Subject: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable
> dpm
> >> by
> >>>> default on BTC
> >>>>
> >>>> Hi Alexander,
> >>>>
> >>>> A kernel bug report was opened against Ubuntu [0].  After a kernel
> >>>> bisect, it was found that reverting the following commit resolved this
> bug:
> >>>>
> >>>> commit c08abf11900e19b14dd3a0cc3d105bd74519cd18
> >>>> Author: Alex Deucher <alexander.deucher@amd.com>
> >>>> Date:   Mon Jul 14 12:01:40 2014 -0400
> >>>>
> >>>>     drm/radeon: re-enable dpm by default on BTC
> >>>>
> >>>> The regression was introduced as of v3.17-rc1 and still exists in
> >>>> current mainline.  It has also made it's way into the stable releases.
> >>>>
> >>>> I was hoping to get your feedback, since you are the patch author.  Do
> >>>> you think gathering any additional data will help diagnose this issue,
> >>>> or would it be best to submit a revert request?
> >>>>
> >>> Does revering b2dccf24e77 help?  I'd hate to revert this patch because it
> >> disables power management for a whole family of chips.  If it doesn't help
> I'd
> >> prefer to just add a quirk to disable it for the specific problematic board.
> >> Commit b2dccf24e77 was added to mainline as of v3.18-rc1 and was not
> >> cc'd to stable.  We are also seeing this issue in the 3.13.y stable
> >> kernel, which does not have commit b2dccf24e77 applied.  However, we
> can
> >> test reverting it in mainline?
> > Nope.  Won't make a difference.  The attached patch adds a quirk list for
> dpm which will fix the issue for the affected boards.
> >
> > Alex
> Thanks again for the patch, Alex.  The bug reporter has tested a 3.16
> kernel with the patch and says it fixes the bug.

I'll queue it up for 3.19-fixes and cc stable.

Thanks,

Alex

> 
> 
> >
> >>> Alex
> >>>
> >>>> Thanks,
> >>>>
> >>>> Joe
> >>>>
> >>>> [0] http://pad.lv/1386534

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
