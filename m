Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab3EWRNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:13:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53379 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953Ab3EWRNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:13:50 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for
 am33xx
Thread-Topic: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for
 am33xx
Thread-Index: AQHOV3sDeuljQaJjrUaNxyq64bPttJkSTkcAgACzRiA=
Date: Thu, 23 May 2013 17:13:44 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EAE3EBF@DBDE04.ent.ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
 <1369288888-8614-9-git-send-email-ravibabu@ti.com>
 <519E275A.5020200@cogentembedded.com>
In-Reply-To: <519E275A.5020200@cogentembedded.com>
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

Sergei

>>
>> +		phy1: usbphy-gs70@44e10620 {
>> +			compatible = "ti,dsps-usbphy";
>> +			reg = <0x44e10620 0x8
>> +			       0x44e10648 0x4>;
>> +			reg-names = "phy_ctrl","phy_wkup";
>> +			id = <0>;
>> +		};
>> +
>> +		phy2: usbphy-gs70@44e10628 {
>> +			compatible = "ti,dsps-usbphy";
>> +			reg = <0x44e10628 0x8
>> +			       0x44e10648 0x4>;

> The second register conflicts with phy1.

The two instances of phy uses common phy wakeup register.

--
Ravi B
