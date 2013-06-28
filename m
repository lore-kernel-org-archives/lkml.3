Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3F1NW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:22:27 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:23300 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab3F1NW0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:22:26 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-2.tower-180.messagelabs.com!1372425743!22146051!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [RFC V1] COMMIT 1: DA9210 driver files
Thread-Topic: [RFC V1] COMMIT 1: DA9210 driver files
Thread-Index: AQHObmXY+PFPby+OME2lP/6mSPiChZlHqFwJgANbsR+AABvPkA==
Date: Fri, 28 Jun 2013 13:22:21 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB71D6D458A@NB-EX-MBX02.diasemi.com>
References: <201306201454.r5KEsAAS010978@swsrvapps-01.diasemi.com>
 <Pine.LNX.4.64.1306211035210.27277@axis700.grange>
 <6ED8E3B22081A4459DAC7699F3695FB71D6CABE7@SW-EX-MBX02.diasemi.com>
 <Pine.LNX.4.64.1306260952160.8856@axis700.grange>
 <6ED8E3B22081A4459DAC7699F3695FB71D6CF2E6@SW-EX-MBX02.diasemi.com>
 <20130628111241.GC27646@sirena.org.uk>
In-Reply-To: <20130628111241.GC27646@sirena.org.uk>
Accept-Language: en-GB, de-DE, en-US
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


On Fri, Jun 28, 2013, Mark Brown wrote:
>
>On Fri, Jun 28, 2013 at 10:32:08AM +0000, Opensource [Steve Twiss] wrote:
>
>Please fix your mail client to word wrap between paragraphs for legibility.
>

Hi Mark,

Apologies for the word-wrap.

>> Dialog are planning to submit a DA9063 driver that 'stands alone'
>> instead of being fully integrated with a combined DA9210 driver (i.e.
>> the one that was uploaded to the mailing list about a year ago).
>> Having said that, there will be a strong similarity between the
>> combined DA9063/DA9210 mailing-list driver and the upcoming
>> stand-alone DA9063 driver.
>
>If there's a lot of similarity then one of the obvious review comments is going to be that
>the two drivers should be merged to promote code reuse.

I should have been clearer.

The DA9063 and DA9210 are two totally different devices. Both in
function and in size. It was a mistake to implement one single driver
for two separate devices.

Also, I meant that before I submit the new stand-alone DA9063 driver,
I will ensure that I make use of any 'request for comments' made
during previous postings.

Sorry for the confusion.
Thanks,
Steve


