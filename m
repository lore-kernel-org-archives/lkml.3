Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3EXFeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:34:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55026 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3EXFeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:34:08 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for
 am33xx
Thread-Topic: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for
 am33xx
Thread-Index: AQHOV3sDeuljQaJjrUaNxyq64bPttJkSTkcAgACzRiD//40XAIABKrbg
Date: Fri, 24 May 2013 05:34:02 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EAE52A3@DBDE04.ent.ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
 <1369288888-8614-9-git-send-email-ravibabu@ti.com>
 <519E275A.5020200@cogentembedded.com>
 <6C6B28D4DC342643927BEAFCE8707BF63EAE3EBF@DBDE04.ent.ti.com>
 <519E5D58.5020002@cogentembedded.com>
In-Reply-To: <519E5D58.5020002@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Re: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for am33xx

Hello.

On 05/23/2013 09:13 PM, B, Ravi wrote:

>
>>> +		phy1: usbphy-gs70@44e10620 {
>>> +			compatible = "ti,dsps-usbphy";
>>> +			reg = <0x44e10620 0x8
>>> +			       0x44e10648 0x4>;
>>> +			reg-names = "phy_ctrl","phy_wkup";
>>> +			id = <0>;
>>> +		};
>>> +
>>> +		phy2: usbphy-gs70@44e10628 {
>>> +			compatible = "ti,dsps-usbphy";
>>> +			reg = <0x44e10628 0x8
>>> +			       0x44e10648 0x4>;
>> The second register conflicts with phy1.
> The two instances of phy uses common phy wakeup register.

>>     That's why there is a resource conflict. Have you actually tried to instantiate the devices out of such tree?
>>This register should be declared somewhere above the PHYs I think...

I did not face any problem with this, I have tested both instances of phy used by dual instance controller, worked fine. 
What do you suggest, in case of common register which both phy have to use this for wakeup functionality.  
The DT should support this.  What do you suggest in such case?

--
Ravi B

