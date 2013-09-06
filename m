Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab3IFKyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:54:45 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.116]:55293 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968Ab3IFKyo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:54:44 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2013 06:54:44 EDT
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-9.tower-194.messagelabs.com!1378464479!8469905!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
From: Steve Twiss <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: DA9063 driver development
Thread-Topic: DA9063 driver development
Thread-Index: Ac6qSlt6xry7hiP+S8yndGJ8KdrZmg==
Date: Fri, 6 Sep 2013 10:47:58 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB732FD0B57@SW-EX-MBX02.diasemi.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am late into the discussion about the DA9063 driver because I missed
the e-mail thread around 24th July 
(https://lkml.org/lkml/2013/7/24/460)
so I only recently noticed that a DA9063 driver from Philipp Zabel 
had been submitted and accepted to linux-next.

I also noted that this driver was using a previous patch-set as its baseline;
sent by Krystian Garbaciak over a year ago. Given that this original 
patch-set was not accepted, and the production of the DA9063 chip has 
advanced since the last submission, we were holding off the final DA9063 
driver until later. 

As I discussed earlier in https://lkml.org/lkml/2013/6/28/170 I was in 
the process of getting this driver ready for submission to the kernel.

It is well understood that any early submission of our driver to the 
community (around v3.6) meant that this sort of external driver development 
could happen without any further input from Dialog. However, this driver:

- is based on something that is a year old and now out of date; 
- it cannot support the most recent mass-production release of DA9063 silicon; 

Is it possible to remove this driver from linux-next so these issues 
can be resolved by Dialog?

Regards,
Steve Twiss

