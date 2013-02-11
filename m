Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3BKRgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:36:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35188 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab3BKRg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:36:29 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: RE: [PATCH V2] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Topic: [PATCH V2] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Index: AQHOCCSeeDJo8q2CGUu0t11Gm6LTiph0h3uAgABkiqA=
Date: Mon, 11 Feb 2013 17:36:23 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229B976F@DBDE01.ent.ti.com>
References: <1360565374-1553-1-git-send-email-j-keerthy@ti.com>
 <20130211170525.GK4607@opensource.wolfsonmicro.com>
In-Reply-To: <20130211170525.GK4607@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.113.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Monday, February 11, 2013 10:35 PM
> To: J, KEERTHY
> Cc: linux-kernel@vger.kernel.org; lgirdwood@gmail.com
> Subject: Re: [PATCH V2] Regulator: Reorder the min max assignment in
> the sequence of regulator_set_voltage function
> 
> On Mon, Feb 11, 2013 at 12:19:34PM +0530, J Keerthy wrote:
> 
> > The min and max values for regulators are getting assigned before
> > actually the voltage is set. So making sure that min and max values
> > are assigned only if the voltage is successfully set else keeping the
> > last successfully set voltage's min and max values.
> 
> > This is boot tested on OMAP4430 and OMAP4460 boards.
> 
> This seems fine but doesn't apply against topic/core or -next, can you
> please regenerate against topic/core and resend?

Ok. I will rebase.

> 
> > V2: Fixed comment from Mark. Introduced local variables to hold
> > current min and max values.
> 
> Don't include things like this in the changelog, include them after the
> --- as covered in SubmittingPatches.

Ok.
