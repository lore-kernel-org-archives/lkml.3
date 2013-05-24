Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3EXFeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:34:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760Ab3EXFeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:34:19 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v1 2/9] usb: musb: nop: remove unused
 nop_xceiv_(un)register APIs from glue
Thread-Topic: [PATCH v1 2/9] usb: musb: nop: remove unused
 nop_xceiv_(un)register APIs from glue
Thread-Index: AQHOV3r9vEl26qqbfkypuoIrrrzucpkSTMAAgACy8zD//4/wAIABK5vQ
Date: Fri, 24 May 2013 05:34:13 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EAE52AA@DBDE04.ent.ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
 <1369288888-8614-3-git-send-email-ravibabu@ti.com>
 <519E2612.5000904@cogentembedded.com>
 <6C6B28D4DC342643927BEAFCE8707BF63EAE3E31@DBDE04.ent.ti.com>
 <519E5E2E.4070104@cogentembedded.com>
In-Reply-To: <519E5E2E.4070104@cogentembedded.com>
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


Subject: Re: [PATCH v1 2/9] usb: musb: nop: remove unused nop_xceiv_(un)register APIs from glue

Hello.

On 05/23/2013 09:07 PM, B, Ravi wrote:

>>> removed unused nop xceiv (un_)register API's from all musb platform 
>>> drivers
>>     Since when are they unused?
> Please refer to commit id 662dca54 : usb: otg: support for multiple transceivers by a single controller.
> Usb_get_phy() is used to get the of phy used by controller, phy bindings are done through DT.

>    Why are you sure that all these platforms support DT (in all configurations)?
> It seems to me that you're simply breaking the patched glue layers with this patch.
> I'll let Felipe decide the fate of this patch though...

You are correct, the bindings of phy and controller need not to done through DT alone, there is a saperate API
Phy API's available for such bindings done in respective board platform files. 

>
>>> Signed-off-by: Ravi Babu <ravibabu@ti.com>
> --
> Ravi B

WBR, Sergei

