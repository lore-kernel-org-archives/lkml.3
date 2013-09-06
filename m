Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3IFK51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:57:27 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.151]:52330 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab3IFK50 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:57:26 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2013 06:57:26 EDT
X-Env-Sender: david.chen@diasemi.com
X-Msg-Ref: server-12.tower-180.messagelabs.com!1378464618!33607394!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: David Dajun Chen <david.chen@diasemi.com>
To: Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: DA9063 driver development
Thread-Topic: DA9063 driver development
Thread-Index: Ac6qSlt6xry7hiP+S8yndGJ8KdrZmgApGuTA
Date: Fri, 6 Sep 2013 10:50:18 +0000
Message-ID: <A0A72D937C18F64E89EDAB73B0232777BAF39D2F@SW-EX-MBX02.diasemi.com>
References: <6ED8E3B22081A4459DAC7699F3695FB732FD0B57@SW-EX-MBX02.diasemi.com>
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB732FD0B57@SW-EX-MBX02.diasemi.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.21.221]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could copy me the mfd.c file of da9063 in the lkml?

-----Original Message-----
From: Steve Twiss
Sent: 06 September 2013 11:48
To: Mark Brown; Philipp Zabel
Cc: Lee Jones; Samuel Ortiz; LKML
Subject: DA9063 driver development

Hello,

I am late into the discussion about the DA9063 driver because I missed the e-mail thread around 24th July
(https://lkml.org/lkml/2013/7/24/460)
so I only recently noticed that a DA9063 driver from Philipp Zabel had been submitted and accepted to linux-next.

I also noted that this driver was using a previous patch-set as its baseline; sent by Krystian Garbaciak over a year ago. Given that this original patch-set was not accepted, and the production of the DA9063 chip has advanced since the last submission, we were holding off the final DA9063 driver until later.

As I discussed earlier in https://lkml.org/lkml/2013/6/28/170 I was in the process of getting this driver ready for submission to the kernel.

It is well understood that any early submission of our driver to the community (around v3.6) meant that this sort of external driver development could happen without any further input from Dialog. However, this driver:

- is based on something that is a year old and now out of date;
- it cannot support the most recent mass-production release of DA9063 silicon;

Is it possible to remove this driver from linux-next so these issues can be resolved by Dialog?

Regards,
Steve Twiss

Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

Please consider the environment before printing this e-mail


