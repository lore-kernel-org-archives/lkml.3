Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3BUD0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:26:00 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50329 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3BUDZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:25:58 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>
Subject: RE: [PATCH V3] i2c: davinci: update to devm_* API
Thread-Topic: [PATCH V3] i2c: davinci: update to devm_* API
Thread-Index: AQHOBTG5bfG08VYfCUa21M7+Bi8x+Zh6+W6AgAjAIhA=
Date: Thu, 21 Feb 2013 03:25:34 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701583A28@DBDE01.ent.ti.com>
References: <1360241520-11476-1-git-send-email-manishv.b@ti.com>
 <20130215190943.GB4351@the-dreams.de>
In-Reply-To: <20130215190943.GB4351@the-dreams.de>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram

On Sat, Feb 16, 2013 at 00:39:43, Wolfram Sang wrote:
> On Thu, Feb 07, 2013 at 06:22:00PM +0530, Vishwanathrao Badarkhe, Manish wrote:
> > Update the code to use devm_* API so that driver core will manage 
> > resources.
> > Also, if "devm_request_and_ioremap" fails return -EADDRNOTAVAIL 
> > instead of -EBUSY.
> > 
> > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> 
> Basically OK, please resend when devm_ioremap_resource hits mainline in 3.9.

Thanks for pointing this out. Sure, I will resend this patch once 
devm_ioremap_resource hits mainline in 3.9.

Regards, 
Manish
