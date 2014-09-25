Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaIYNa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:30:59 -0400
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:62603
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751574AbaIYNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:30:57 -0400
X-Greylist: delayed 1122 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 09:30:56 EDT
Message-ID: <542410D3.2060507@freescale.com>
Date: Thu, 25 Sep 2014 15:55:47 +0300
From: Laurentiu Tudor <b10716@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>, <mturquette@linaro.org>
CC: <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add CLK_OF_DECLARE
 support
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: DB4PR03CA0013.eurprd03.prod.outlook.com (25.160.39.151) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(24454002)(377454003)(479174003)(189002)(199003)(33656002)(120916001)(47776003)(20776003)(85306004)(92566001)(102836001)(76482002)(50466002)(77096002)(87976001)(101416001)(64706001)(65956001)(46102003)(83072002)(65806001)(85852003)(95666004)(76176999)(23676002)(92726001)(64126003)(80022003)(107046002)(31966008)(77982003)(81342003)(87266999)(4396001)(79102003)(81542003)(74662003)(21056001)(99136001)(83506001)(42186005)(105586002)(66066001)(50986999)(65816999)(54356999)(90102001)(97736003)(74502003)(36756003)(10300001)(99396003)(106356001)(83322001)(80316001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB314;H:[10.171.73.112];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingchang,

On 09/23/2014 09:46 AM, Jingchang Lu wrote:
> The IP is shared by PPC and ARM, this renames it to qoriq for better
> represention, and this also adds the CLK_OF_DECLARE support for being
> initialized by of_clk_init() on ARM.
> 

I think you need to also update drivers/cpufreq/Kconfig.powerpc
to use the renamed config option.

---
Best Regards, Laurentiu
