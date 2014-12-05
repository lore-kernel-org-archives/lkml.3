Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaLEPEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:04:33 -0500
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:8736
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751135AbaLEPEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:04:32 -0500
Message-ID: <5481C5C7.9080503@freescale.com>
Date: Fri, 5 Dec 2014 16:48:39 +0200
From: Claudiu Manoil <claudiu.manoil@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arseny Solokha <asolokha@kb.kras.ru>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <haokexin@gmail.com>
Subject: Re: [PATCH 0/2] DMA API usage fixes in gianfar
References: <1417775874-17775-1-git-send-email-asolokha@kb.kras.ru>
In-Reply-To: <1417775874-17775-1-git-send-email-asolokha@kb.kras.ru>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(199003)(51704005)(479174003)(377454003)(189002)(24454002)(120886001)(46102003)(92566001)(80316001)(4396001)(120916001)(97736003)(6806004)(99396003)(15975445007)(19580395003)(64706001)(21056001)(87936001)(20776003)(47776003)(50466002)(65956001)(65806001)(33656002)(77096005)(65816999)(104016003)(76176999)(54356999)(87266999)(68736005)(50986999)(110136001)(62966003)(81156004)(106466001)(105606002)(84676001)(86362001)(83506001)(23746002)(31966008)(36756003)(107046002)(69596002)(77156002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0632;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0632;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BY2PR0301MB0632;
X-Forefront-PRVS: 04163EF38A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=claudiu.manoil@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0632;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/2014 12:37 PM, Arseny Solokha wrote:
> Hello.
>
> This patch set fixes DMA API usage issues in gianfar ethernet driver
> reported by the kernel w/ DMA API debug enabled.
>
> There were even reports that the kernel sometimes oopsed in the past
> because of kernel paging request handling failures, though it was likely
> observed on some ancient versions. And while I personally doesn't have
> any strong evidence of this, there's no reason to let these possible
> failures live any longer.
>
> Arseny Solokha (2):
>    gianfar: handle map error in gfar_new_rxbdp()
>    gianfar: handle map error in gfar_start_xmit()
>
>   drivers/net/ethernet/freescale/gianfar.c | 49 ++++++++++++++++++++++++++------
>   1 file changed, 41 insertions(+), 8 deletions(-)
>

Thanks but please note that Kevin Hao already provided a fix for this issue:
http://permalink.gmane.org/gmane.linux.network/336274

His patch was only deferred for testing (and bandwidth) reasons.
I will try to resend his patch to the netdev list today if possible,
I apologize for the delay.
Also note that there are some issues with your patches.
As said before, I will resubmit Kevin Hao's patch.

Thanks,
Claudiu

