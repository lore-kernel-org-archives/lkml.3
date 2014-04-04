Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaDDOtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:49:40 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:52617 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaDDOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140404144244.GV14763@sirena.org.uk>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
	<1396523431-14519-2-git-send-email-harinik@xilinx.com>
	<20140403213446.GB14763@sirena.org.uk>
	<CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
	<20140404100919.GO14763@sirena.org.uk>
	<CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
	<20140404124637.GT14763@sirena.org.uk>
	<CAFcVEC+FAAxxxxA8PgcTzLU5UFu=pkDEM4Li06dRmEwA95sz_g@mail.gmail.com>
	<20140404144244.GV14763@sirena.org.uk>
Date: Fri, 4 Apr 2014 20:19:37 +0530
Message-ID: <CAFcVECKEMa9agyk8BQAbdadmggscwUk=9x-3nAM1TZiAoGf0MA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] devicetree: Add devicetree bindings documentation
 for Cadence SPI
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Apr 4, 2014 at 8:12 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Apr 04, 2014 at 07:38:14PM +0530, Harini Katakam wrote:
>
>> OK. I understand.
>> Can you comment on the case where a decoder is used?
>
>> There is support for adding a decoder where extended slaves can be selected
>> through the IP's control register.
>> (This is not currently implemented in the driver but will be in the future.)
>
>> How should the driver know whether it is 4 or 16 select lines for example?
>> This has to be written to master->num_chipselect.
>
> That's the sort of case where it's useful yes - depending on how the
> implementation is done it may be sensible to just have a property
> specifying if a decoder is there (if it just changes the encoding in the
> register for example).

OK, great. That approach will work.

Regards,
Harini
