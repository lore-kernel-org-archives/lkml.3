Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaJXPqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:46:51 -0400
Received: from mail-bn1bon0095.outbound.protection.outlook.com ([157.56.111.95]:30624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755756AbaJXPqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:46:50 -0400
Message-ID: <544A7384.7060104@opensource.altera.com>
Date: Fri, 24 Oct 2014 10:43:00 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <pza@pengutronix.de>
CC: <p.zabel@pengutronix.de>, <dinh.linux@gmail.com>,
        <atull@opensource.altera.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] reset: add reset_control_status helper function
References: <1412954474-25775-1-git-send-email-dinguyen@opensource.altera.com> <54491859.5010007@opensource.altera.com> <20141024120706.GA27296@pengutronix.de>
In-Reply-To: <20141024120706.GA27296@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR0601CA0014.namprd06.prod.outlook.com (25.160.162.24)
 To BY1PR0301MB1191.namprd03.prod.outlook.com (25.160.195.15)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1191;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(51704005)(189002)(199003)(479174003)(377454003)(24454002)(99396003)(97736003)(110136001)(107046002)(106356001)(76482002)(120916001)(64126003)(77096002)(50466002)(105586002)(95666004)(31966008)(83506001)(19580395003)(92726001)(23746002)(19580405001)(54356999)(50986999)(76176999)(42186005)(65816999)(87266999)(59896002)(85306004)(66066001)(87976001)(122386002)(64706001)(92566001)(33656002)(102836001)(86362001)(85852003)(65806001)(4396001)(20776003)(80022003)(46102003)(101416001)(80316001)(21056001)(40100003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1191;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1174;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 07:07 AM, Philipp Zabel wrote:
> Hi Dinh,
> 
> On Thu, Oct 23, 2014 at 10:01:45AM -0500, Dinh Nguyen wrote:
>> Hi Philipp,
>>
>> On 10/10/2014 10:21 AM, dinguyen@opensource.altera.com wrote:
>>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>>
>>> There are cases where a system will want to read a reset status bit before
>>> doing any other toggling. Add a reset_control_status helper function to the
>>> reset controller API.
>>>
>>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
>>> ---
> [...]
>> Do you have any further comments on this version of that patch? If not,
>> can I get an Ack-by?
> 
> I have applied it here:
> git://git.pengutronix.de/git/pza/linux.git reset-for-3.19
> 
> Sorry about the delayed feedback. I was waiting for the Meson reset patches
> before pushing the branch, but that might still take a while.
> 
Ah thanks. I can send up a patch that populates status for SOCFPGA then.

Dinh

