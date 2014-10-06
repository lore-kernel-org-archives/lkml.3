Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaJFOtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:49:13 -0400
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:3520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751777AbaJFOtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:49:11 -0400
Message-ID: <5432ABCE.90208@freescale.com>
Date: Mon, 6 Oct 2014 09:48:46 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>,
        Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>,
        <bhamciu1@freescale.com>, <R89243@freescale.com>,
        <Geoff.Thorpe@freescale.com>, <bhupesh.sharma@freescale.com>,
        <nir.erez@freescale.com>, <richard.schmitt@freescale.com>
Subject: Re: [PATCH 3/3 v3] drivers/bus: Device driver for FSL-MC DPRC devices
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com>	<1412429015-30564-4-git-send-email-German.Rivera@freescale.com> <CAOZdJXWP4bwWiEcX10i4j96z49QahtpywK=XiuHm9VXWa0zOKw@mail.gmail.com>
In-Reply-To: <CAOZdJXWP4bwWiEcX10i4j96z49QahtpywK=XiuHm9VXWa0zOKw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BN1PR02CA0019.namprd02.prod.outlook.com (10.141.56.19) To
 BLUPR03MB328.namprd03.prod.outlook.com (10.141.48.27)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB328;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03569407CC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(189002)(24454002)(164054003)(377454003)(51704005)(199003)(479174003)(36756003)(64706001)(85306004)(20776003)(105586002)(66066001)(95666004)(107046002)(50986999)(101416001)(106356001)(47776003)(122386002)(40100001)(21056001)(77096002)(97736003)(65956001)(110136001)(19580395003)(10300001)(33656002)(92726001)(120916001)(23676002)(76176999)(4396001)(76482002)(46102003)(85852003)(50466002)(86362001)(80022003)(99396003)(87976001)(19580405001)(102836001)(83506001)(65816999)(54356999)(42186005);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB328;H:[10.81.33.65];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/05/2014 09:53 AM, Timur Tabi wrote:
> On Sat, Oct 4, 2014 at 8:23 AM, J. German Rivera
> <German.Rivera@freescale.com> wrote:
>> +EXPORT_SYMBOL_GPL(dprc_scan_objects);
>
> I didn't notice this earlier, but I it was Freescale policy to use
> EXPORT_SYMBOL() instead of EXPORT_SYMBOL_GPL().  Has that changed?
>
Please see change history in the cover letter for this patch series.

Thanks,

German
