Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3EWRJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:09:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53457 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918Ab3EWRJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:09:11 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v1 7/9] usb: musb: dsps: use get-usb-phy by phandle for
 multi instance
Thread-Topic: [PATCH v1 7/9] usb: musb: dsps: use get-usb-phy by phandle for
 multi instance
Thread-Index: AQHOV3sDKezsxzAOtEeIsJ9gYcoR2JkSTcCAgACzfuA=
Date: Thu, 23 May 2013 17:09:05 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EAE3E73@DBDE04.ent.ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
 <1369288888-8614-8-git-send-email-ravibabu@ti.com>
 <519E26E9.3040301@cogentembedded.com>
In-Reply-To: <519E26E9.3040301@cogentembedded.com>
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

> Subject: Re: [PATCH v1 7/9] usb: musb: dsps: use get-usb-phy by phandle for multi instance

> On 23-05-2013 10:01, Ravi Babu wrote:

>> In case of mutli instance support, use get-phy object using phandle to 
>> return to repsective phy xceiv object for each instance

>   Only "respective" and s/xceiv/transceiver/.

Ok. 

>> Signed-off-by: Ravi Babu <ravibabu@ti.com>

--
Ravi B
