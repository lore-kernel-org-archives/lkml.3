Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaKKUt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:49:28 -0500
Received: from ezexch.ezchip.com ([212.179.42.101]:42457 "EHLO ezchip.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751878AbaKKUt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:49:27 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2014 15:49:26 EST
Message-ID: <546274B2.6080206@ezchip.com>
Date: Tue, 11 Nov 2014 15:42:26 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>, <rdunlap@infradead.org>,
        <rickard_strandqvist@spectrumdigital.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: gxio: Export symbols for module using in
 'mpipe.c'
References: <545F42A3.5050108@gmail.com>
In-Reply-To: <545F42A3.5050108@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: DM2PR00CA0015.namprd00.prod.outlook.com (25.160.243.25) To
 AM3PR02MB0536.eurprd02.prod.outlook.com (25.160.6.142)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0536;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0536;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(41574002)(189002)(51704005)(24454002)(479174003)(377454003)(199003)(64126003)(66066001)(65806001)(65956001)(80316001)(19580405001)(36756003)(19580395003)(59896002)(83506001)(101416001)(15202345003)(62966003)(2501002)(15975445006)(87976001)(50466002)(95666004)(21056001)(122386002)(23756003)(4396001)(33656002)(42186005)(107046002)(65816999)(106356001)(50986999)(105586002)(87266999)(54356999)(76176999)(20776003)(47776003)(120916001)(31966008)(2201001)(92566001)(46102003)(77156002)(77096003)(97736003)(64706001)(40100003)(102836001)(86362001)(99396003)(92726001)(2101003)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM3PR02MB0536;H:[10.7.0.239];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0536;
X-OriginatorOrg: ezchip.com
X-TM-AS-Product-Ver: SMEX-11.0.0.1191-7.500.1018-21094.002
X-TM-AS-Result: No--4.547600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/9/2014 5:32 AM, Chen Gang wrote:
> 'gxio_mpipe_adjust_timestamp', 'gxio_mpipe_link_instance',
> 'gxio_mpipe_get_timestamp', and 'gxio_mpipe_set_timestamp' may be use by
> other tile modules, so export them.
>
> The related error (with allmodconfig under tile):
>
>      MODPOST 4002 modules
>    ERROR: "gxio_mpipe_link_instance" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>    ERROR: "gxio_mpipe_get_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>    ERROR: "gxio_mpipe_set_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>    ERROR: "gxio_mpipe_adjust_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>
> Signed-off-by: Chen Gang<gang.chen.5i5j@gmail.com>
> ---
>   arch/tile/gxio/mpipe.c | 4 ++++
>   1 file changed, 4 insertions(+)

Thanks!  Taken into the tile tree.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

