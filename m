Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaJWSac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:30:32 -0400
Received: from mail-bn1bon0054.outbound.protection.outlook.com ([157.56.111.54]:27200
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753557AbaJWSab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:30:31 -0400
Message-ID: <54494861.80102@opensource.altera.com>
Date: Thu, 23 Oct 2014 13:26:41 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com> <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com> <9429092.fliZzSsbVp@amdc1032> <A2CA0424C0A6F04399FB9E1CD98E0304844E54AC@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E54AC@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR0201CA0009.namprd02.prod.outlook.com (25.160.191.147)
 To BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(189002)(199003)(479174003)(377454003)(51704005)(24454002)(164054003)(80022003)(99396003)(86362001)(107046002)(77096002)(76482002)(105586002)(21056001)(106356001)(65806001)(54356999)(66066001)(97736003)(64706001)(50986999)(65816999)(31966008)(95666004)(120916001)(76176999)(23746002)(50466002)(20776003)(117636001)(4396001)(92726001)(92566001)(40100003)(122386002)(85306004)(93886004)(87976001)(102836001)(83506001)(85852003)(46102003)(47776003)(42186005)(19580395003)(101416001)(19580405001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 01:28 PM, Paul Zimmerman wrote:
>> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
>> Sent: Wednesday, October 22, 2014 5:26 AM
>>
>> On Monday, October 20, 2014 01:52:06 PM dinguyen@opensource.altera.com wrote:
>>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>>
>>>  config USB_DWC2_PLATFORM
>>>  	bool "DWC2 Platform"
>>> -	depends on USB_DWC2_HOST
>>>  	default USB_DWC2_HOST
>>
>> It should be "default USB_DWC2_HOST || USB_DWC2_PERIPHERAL" because
>> USB_DWC2_PLATFORM replaces current USB_DWC2_PERIPHERAL functionality.
>>
>> Additionaly USB_DWC2_PLATFORM should be changed to tristate
>> (USB_DWC2_PERIPHERAL was a tristeate before your changes).
> 
> Dinh, I think this is a good point. Is there any reason why
> USB_DWC2_PLATFORM (and USB_DWC2_PCI for that matter) can't be
> tristate? That's what DWC3 does.
> 

Yes, in my v6, I have made this change.

Thanks,
Dinh
