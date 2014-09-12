Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaILUF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:05:29 -0400
Received: from mail-bn1on0058.outbound.protection.outlook.com ([157.56.110.58]:32384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751488AbaILUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:05:28 -0400
X-Greylist: delayed 3552 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 16:05:27 EDT
Message-ID: <54133B9C.1060205@opensource.altera.com>
Date: Fri, 12 Sep 2014 13:29:48 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: <paulz@synopsys.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 00/12] usb: dwc2: Add support for dual role
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com> <61330867.p68uWknPkl@amdc1032>
In-Reply-To: <61330867.p68uWknPkl@amdc1032>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0048.namprd05.prod.outlook.com (10.141.20.18) To
 BN3PR0301MB1188.namprd03.prod.outlook.com (25.160.156.15)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(24454002)(51914003)(189002)(377454003)(479174003)(199003)(51704005)(77096002)(46102001)(20776003)(85306004)(4396001)(64706001)(76482001)(83322001)(107046002)(54356999)(87266999)(92566001)(106356001)(105586002)(65806001)(102836001)(76176999)(86362001)(50986999)(110136001)(95666004)(97736003)(47776003)(19580405001)(99136001)(85852003)(65956001)(80022001)(83506001)(90102001)(59896002)(79102001)(74662001)(81342001)(42186005)(81542001)(66066001)(65816999)(99396002)(80316001)(21056001)(31966008)(64126003)(19580395003)(92726001)(87976001)(101416001)(23746002)(50466002)(77982001)(33656002)(83072002)(74502001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1188;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 11:44 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> [ added linux-kernel ML to cc: ]
> 
> Hi,
> 
> On Tuesday, August 26, 2014 11:19:51 AM dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>
>> Hello,
>>
>> This is version 4 of the patch series that combines the dwc2 gadget and host
>> driver into a single dual role driver. Here are the main differences from V2:
>>
>> - Patch 9/12 : Move spin_lock_init() earlier up in the function to guarantee
>>   no locks can be taken before the initializing the spin_lock.
>>
>> - Patch 12/12 : Same as patch 9/12.
>>
>> - Added Acked-by: paulz for all patches except patch 9/12 and 12/12.
>>
>> For v4, I have rebased the series on top of Greg KH's USB usb-linus tree
>> [9b2667f usb: dwc2: gadget: Set the default EP max packet value as 8 bytes]
>> and on top of the following patches that have not yet been applied:
>>
>> Doug Anderson: usb: dwc2: Read GNPTXFSIZ when in forced HOST mode
>> Kever Yang : usb: dwc2: add 'mode' which based on Kconfig select or dts setting
>> Robert Baldyga : usb: dwc2/gadget: fix series <- 12 patches
>>
>> As usual, tested on SOCFPGA(host, gadget, and dual-role) and on Rpi-B
>> (host mode only).
>>
>> I have pushed this series to a git repo to make it more convenient for people
>> to test/review.
>>
>> git://git.rocketboards.org/linux-socfpga-next.git dwc2_dual_role_v4
> 
> Please also add linux-kernel ML to next revision of the patchset
> (helps to get reviewers).
> 
> Also sorry for the late review but people are not yet used to
> the fact that dwc2 now also means "our" good old s3c-hsotg. ;-)
> 

Thanks for the review. I'll try to address all of your comments in the
next version.

Dinh

