Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbaJaPFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:05:06 -0400
Received: from mail-bn1on0086.outbound.protection.outlook.com ([157.56.110.86]:9184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932248AbaJaPFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:05:04 -0400
Message-ID: <5453A433.5020904@opensource.altera.com>
Date: Fri, 31 Oct 2014 10:01:07 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <paulz@synopsys.com>, <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 5/8] usb: dwc2: Add call_gadget functions for perpheral
 mode interrupts
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-6-git-send-email-dinguyen@opensource.altera.com> <20141030140143.GE6482@saruman>
In-Reply-To: <20141030140143.GE6482@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR09CA0049.namprd09.prod.outlook.com (10.255.214.177) To
 BN3PR0301MB1187.namprd03.prod.outlook.com (25.160.156.149)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1187;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(199003)(164054003)(24454002)(189002)(479174003)(377454003)(4396001)(87266999)(50986999)(76176999)(65816999)(95666004)(33656002)(87976001)(92726001)(80316001)(92566001)(19580395003)(23746002)(54356999)(64126003)(122386002)(31966008)(62966003)(77156002)(77096003)(83506001)(20776003)(99396003)(110136001)(66066001)(120916001)(2351001)(64706001)(50466002)(65806001)(105586002)(102836001)(106356001)(59896002)(65956001)(86362001)(46102003)(101416001)(575784001)(107046002)(47776003)(19580405001)(40100003)(97736003)(42186005)(21056001)(19627235001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1187;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/30/2014 09:01 AM, Felipe Balbi wrote:
> On Tue, Oct 28, 2014 at 06:25:46PM -0500,
> dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>> 
>> Update the dwc2 wakeup and suspend interrupt functions to use
>> call_gadget when the IP is in peripheral mode.
> 
> it seems like you're actually fixing a bug here. Those calls
> weren't there before.
> 

This patch can be sent separately from this series.

Thanks,
Dinh
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUU6QzAAoJEBmUBAuBoyj0XpIQAKLQxsksyfEBAOWNwapO1Grx
jMK9+QpqZuGwo5Gha905iAO1Q/XP5tHvkLBzGyeEpNhEqBWXTTAvu1i2EToSiNId
JTtae/eJA5xfxoljULqL3Vuy1SfOt+EdBHoMdn/vQQfBp9kUiqfJNgZeUsDgvbBK
7xNfdocMQjqPPbseNGL3193aasOFyZdc9sI+ZR3XjeXjNPgzwJzfB9eMZH+zpRKU
nVcWY5UBkw05UnvDNwc4e/+VNpBRj4NLBBLGPleUJ1KXyunUet5r4oCLYLasZaFn
zk6VvovQMUDk9DhnK2d8w6oosmSA/eD8zKn3K3++LV/XGwb5rHP+zC5jpAkbjN/o
4ZudegACKNUiwvo0tfbgtI5no/VzlaArSM6n3WT6Fz5cDveibZbU7z78AqIqRkwF
Ai4+bn510OCgfEEu2rVRXl21r/TAt9r3ujh1mPPUwJ+nWdoxjmm7+0MyKNSeB/Ab
MmVZfQaELLGTOMHH0T0/yr6XX8Bc4LxGtbjVQRlmW7mYfafnzhE+aWAeLnyF4V9r
cA0YE09jOQoXh8WU6k18SKbapF8HDaXSLBcTWnXBR93TQu4U05qx5iB8hEZ7S9NT
z3uQdfgjk8LjhaYWTtSsT29E6oDbvho8h5TF48KiwN4Ud0wagqJq1W3vlGhrgKUd
wy94/mOPpifATM0S4KUr
=qCZw
-----END PGP SIGNATURE-----
