Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaLIPnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:43:14 -0500
Received: from mail-by2on0112.outbound.protection.outlook.com ([207.46.100.112]:43936
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753819AbaLIPnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:43:11 -0500
X-Greylist: delayed 1085 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 10:43:11 EST
From: "Austin, Brian" <Brian.Austin@cirrus.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Jaroslav Kysela" <perex@perex.cz>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Timur Tabi <timur@tabi.org>, Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Li.Xiubo@freescale.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] sound / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Thread-Topic: [PATCH] sound / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Thread-Index: AQHQEPvXZu5aq12gXkCsWDmwCwS6A5yHYkyA
Date: Tue, 9 Dec 2014 15:09:32 +0000
Message-ID: <D0AC6CA0.260F%Brian.Austin@cirrus.com>
In-Reply-To: <2064254.7lXiTpmK64@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.5.130515
x-originating-ip: [141.131.125.33]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F3B38E4FEE1A904B85E89897BF7DEC9A@ad.cirrus.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.3.20;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(24454002)(51704005)(199003)(479174003)(377454003)(54356999)(97756001)(50466002)(102836002)(86362001)(4396001)(77156002)(107046002)(120916001)(62966003)(92566001)(50986999)(46406003)(36756003)(106116001)(106466001)(46102003)(83506001)(19580405001)(66066001)(31966008)(23726002)(64706001)(20776003)(87936001)(2656002)(47776003)(19580395003)(21056001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB045;H:mail1.cirrus.com;FPR:;SPF:Pass;MLV:sfv;PTR:mail1.cirrus.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB045;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB045;
X-Forefront-PRVS: 0420213CCD
Authentication-Results: spf=pass (sender IP is 141.131.3.20)
 smtp.mailfrom=Brian.Austin@cirrus.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB045;
X-OriginatorOrg: cirrus.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/5/14, 8:46 PM, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

>From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
>After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
>selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
>depending on CONFIG_PM_RUNTIME may now be changed to depend on
>CONFIG_PM.
>
>Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under sound/.
>
>Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>---
>
>Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
>PM_SLEEP is selected) which is only in linux-next at the moment (via the
>linux-pm tree).
>
For the cs35l32
Acked-by: Brian Austin <brian.austin@cirrus.com>

