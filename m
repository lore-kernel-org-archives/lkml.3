Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaESKSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:18:55 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33028 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751482AbaESKSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:18:53 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Ricardo Ribalda Delgado'" <ricardo.ribalda@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "auttamchandani@logicube.com" <auttamchandani@logicube.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: RE: [PATCH 3/5] usb: gadget: net2280: Use BIT() macro
Thread-Topic: [PATCH 3/5] usb: gadget: net2280: Use BIT() macro
Thread-Index: AQHPc0rbk/fpxlkMvEexbFMt3HrgRJtHsBLA
Date: Mon, 19 May 2014 10:18:25 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724900B@AcuExch.aculab.com>
References: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
 <1400494205-26566-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1400494205-26566-3-git-send-email-ricardo.ribalda@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado
> Improves readability of the code

Personally I don't find macros like BIT() improve the readability at all.
What next? Maybe:

#define ADD(a, b) ((a) + (b))

	David



