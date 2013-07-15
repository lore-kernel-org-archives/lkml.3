Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3GONQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:16:38 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.105]:55705 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209Ab3GONQg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:16:36 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-14.tower-194.messagelabs.com!1373894191!10461597!3
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: Steve Twiss <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [RFC V2] DA9210 driver files
Thread-Topic: [RFC V2] DA9210 driver files
Thread-Index: AQHOd2gCZZX+PbJuDUi47mb2PgoYbZllubJA
Date: Mon, 15 Jul 2013 12:37:08 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB71D6FB49A@SW-EX-MBX02.diasemi.com>
References: <201307011447.r61Els8t019635@swsrvapps-01.diasemi.com>
 <20130702210617.GA27646@sirena.org.uk>
In-Reply-To: <20130702210617.GA27646@sirena.org.uk>
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


>On 02 July 2013 22:06, Mark Brown wrote:
>>On Mon, Jul 01, 2013 at 03:10:28PM +0100, Steve Twiss wrote:
>
>> The use of regmap_range is not being considered because I am not
>> intending to use PAGE_CON register page selection in any of the driver development.
>
>Makes sense to map things in for diagnostics...

Hi Mark,

I understand you will need regmap_range added so that it follows your
standards and so I will definitely add that into the functionality.

There will be further updates to follow this first release, so I am intending
to add regmap_range during one of those next releases. Because the paged
registers are explicitly removed in this driver, I am hoping that this version
will be sufficient for the moment.

I will resubmit the updated version with all my latest changes and catch
everyone's replies then.

regards,
Steve

