Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab3EWSR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:17:58 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54698 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab3EWSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:17:56 -0400
Message-ID: <519E5D58.5020002@cogentembedded.com>
Date: Thu, 23 May 2013 22:18:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "B, Ravi" <ravibabu@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for am33xx
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com> <1369288888-8614-9-git-send-email-ravibabu@ti.com> <519E275A.5020200@cogentembedded.com> <6C6B28D4DC342643927BEAFCE8707BF63EAE3EBF@DBDE04.ent.ti.com>
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EAE3EBF@DBDE04.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

     That's why there is a resource conflict. Have you actually tried to 
instantiate the devices out of such tree?
This register should be declared somewhere above the PHYs I think...

> --
> Ravi B

WBR, Sergei

