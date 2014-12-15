Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbaLOVbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:31:38 -0500
Received: from mail-bn1bon0094.outbound.protection.outlook.com ([157.56.111.94]:64928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbaLOVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:31:37 -0500
Message-ID: <548F5330.6090508@caviumnetworks.com>
Date: Mon, 15 Dec 2014 13:31:28 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Aleksey Makarov <feumilieu@gmail.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        "Aleksey Makarov" <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 13/14] MIPS: OCTEON: Add register definitions for OCTEON
 III reset unit.
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com> <1418666603-15159-14-git-send-email-aleksey.makarov@auriga.com> <20141215210942.GC10323@fuloong-minipc.musicnaut.iki.fi>
In-Reply-To: <20141215210942.GC10323@fuloong-minipc.musicnaut.iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: BLUPR07CA092.namprd07.prod.outlook.com (25.160.24.47) To
 BN3PR0701MB1105.namprd07.prod.outlook.com (25.160.114.143)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0701MB1105;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BN3PR0701MB1105;
X-Forefront-PRVS: 04267075BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(51704005)(377454003)(189002)(199003)(479174004)(62966003)(64126003)(110136001)(92566001)(46102003)(20776003)(47776003)(97736003)(77156002)(4396001)(36756003)(50466002)(69596002)(81156004)(87266999)(23756003)(76176999)(107046002)(40100003)(31966008)(19580395003)(80316001)(33656002)(54356999)(83506001)(66066001)(105586002)(50986999)(106356001)(64706001)(19580405001)(120916001)(101416001)(99396003)(87976001)(68736005)(42186005)(122386002)(21056001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0701MB1105;H:dl.caveonetworks.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0701MB1105;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0701MB1089;
X-OriginatorOrg: caviumnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2014 21:31:32.6628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 711e4ccf-2e9b-4bcf-a551-4094005b6194
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0701MB1089
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 01:09 PM, Aaro Koskinen wrote:
> Hi,
>
> On Mon, Dec 15, 2014 at 09:03:19PM +0300, Aleksey Makarov wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> Needed by follow-on patches.
>
> Looks like only one of the unions was needed (cvmx_rst_boot)...?
>

This follows the form of the other register definition files.

If Ralf requests it, we would consider deleting some of the currently 
unused definitions.

David Daney


