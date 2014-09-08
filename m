Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaIHLfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:35:01 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:35217 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbaIHLe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:34:58 -0400
Message-ID: <540D9449.3090008@compulab.co.il>
Date: Mon, 08 Sep 2014 14:34:33 +0300
From: Dmitry Lifshitz <lifshitz@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, bcousson@baylibre.com,
        tony@atomide.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
References: <1381402195-29257-1-git-send-email-kishon@ti.com> <1381402195-29257-2-git-send-email-kishon@ti.com> <52580F34.8030809@ti.com> <20140416161619.GH28035@saruman.home>
In-Reply-To: <20140416161619.GH28035@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: lifshitz@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe, Roger

On 04/16/2014 07:16 PM, Felipe Balbi wrote:
> On Fri, Oct 11, 2013 at 05:46:12PM +0300, Roger Quadros wrote:
>> Hi,
>>
>> On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
>>> From: George Cherian <george.cherian@ti.com>
>>>
>>> Added dr_mode property in dwc3 and set its default mode to device.
>>
>> If there is a specific reason why this is not set to "otg", we need
>> to explain it here.
>>
>> AFAIK the port is meant to be used as OTG port.
>
> we still don't have the workaround for dual role ports, I've been
> working on it but still need to retest and make sure it's working fine
> before merging upstream.
>


Does the OTG port suppose to work with OMAP5? I mean role switching 
mechanism?

I'm testing kernel v3.16 with OMAP5 based board (CM-T54).

If I set CONFIG_USB_DWC3_DUAL_ROLE, than nothing is going on when I plug 
some device/host cable into micro USB3.0 port (VBUS/ID detection with 
extcon events works fine).

CONFIG_USB_DWC3_HOST/CONFIG_USB_DWC3_GADGET bring port to appropriate 
mode and it works.

What is the purpose of setting dr_mode = "peripheral" in omap5.dtsi, 
since it is overridden by config options in dwc3_probe()?

Thank you in advance for the assistance,

Dmitry

