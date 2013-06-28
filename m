Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3F1KcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:32:22 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.119]:45789 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab3F1KcT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:32:19 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-12.tower-193.messagelabs.com!1372415529!11138699!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [RFC V1] COMMIT 1: DA9210 driver files
Thread-Topic: [RFC V1] COMMIT 1: DA9210 driver files
Thread-Index: AQHObmXY+PFPby+OME2lP/6mSPiChZlHqFwJgANFEFA=
Date: Fri, 28 Jun 2013 10:32:08 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB71D6CF2E6@SW-EX-MBX02.diasemi.com>
References: <201306201454.r5KEsAAS010978@swsrvapps-01.diasemi.com>
 <Pine.LNX.4.64.1306211035210.27277@axis700.grange>
 <6ED8E3B22081A4459DAC7699F3695FB71D6CABE7@SW-EX-MBX02.diasemi.com>
 <Pine.LNX.4.64.1306260952160.8856@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306260952160.8856@axis700.grange>
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


On Wed, 26 June 2013, Guennadi Liakhovetski wrote:
>
>Hi Steve
>
>On Mon, 24 Jun 2013, Opensource [Steve Twiss] wrote:
>
>[snip]
>
>> Thank you for the comments.
>
>Thanks for your work on this! I've got one more question to you though: it looks like
>you're doing Linux kernel driver open-sourcing for DiaSemi ATM.
>In the past
>
>http://lwn.net/Articles/513859/
>
>a patch series has been submitted by your employer to support the da9063 PMIC. Are
>there plans to continue that work and update the driver? Any specific dates when a new
>submission can be expected?

Hi Guennadi,

Dialog are planning to submit a DA9063 driver that 'stands alone' instead of being fully integrated with a combined DA9210 driver (i.e. the one that was uploaded to the mailing list about a year ago). Having said that, there will be a strong similarity between the combined DA9063/DA9210 mailing-list driver and the upcoming stand-alone DA9063 driver.

This DA9063 work is continuing and it will be submitted to LKML after the DA9210 work has [hopefully] been accepted. In this way I am aiming to try and side-step as many DA9063 submission pitfalls as possible by ensuring any relevant comments from this DA9210 submission work have been added into the new driver.

I hope that helps...

Regards,
Steve

>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer http://www.open-technology.de/
