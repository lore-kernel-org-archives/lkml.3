Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaJGPzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:55:07 -0400
Received: from mail-bn1on0076.outbound.protection.outlook.com ([157.56.110.76]:8324
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754515AbaJGPzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:55:02 -0400
Message-ID: <54340BF6.4030602@opensource.altera.com>
Date: Tue, 7 Oct 2014 10:51:18 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <marex@denx.de>
Subject: Re: socfpga ethernet problems with ethernet in 3.17 with u-boot-2013.01.01
References: <20141007121017.GA20998@amd>
In-Reply-To: <20141007121017.GA20998@amd>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR04CA024.namprd04.prod.outlook.com (10.141.249.142) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(189002)(479174003)(377454003)(24454002)(199003)(5423002)(102836001)(31966008)(107046002)(80316001)(50466002)(54356999)(65816999)(77096002)(85852003)(2201001)(85306004)(230783001)(76482002)(66066001)(101416001)(99396003)(64126003)(97736003)(122386002)(47776003)(83506001)(21056001)(92566001)(64706001)(59896002)(99136001)(107886001)(87266999)(20776003)(106356001)(4396001)(42186005)(50986999)(105586002)(92726001)(87976001)(65806001)(120916001)(86362001)(33656002)(23746002)(46102003)(95666004)(80022003)(76176999)(40100002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1255;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 07:10 AM, Pavel Machek wrote:
> Hi!
> 
> After some testing:
> 
> u-boot-2013.01.01 + linux-3.17 => ethernet does	not work
>                   (unless ethernet is used in u-boot, for example
>                   using ping)
> u-boot-marex-20140920a + linux-3.17 => working ethernet
> 
> One of our guesses is that maybe we don't pull ethernet out of reset
> in the first case?
> 

v3.17 has the reset driver framework that the stmmac driver uses to
deassert the reset.

Dinh

