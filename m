Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab3GWPwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:52:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55436 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3GWPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:52:45 -0400
Message-ID: <51EEA6C8.6090604@wwwdotorg.org>
Date: Tue, 23 Jul 2013 08:52:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Chaiken, Alison" <Alison_Chaiken@mentor.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: The future of DT binding maintainership
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <20130720034647.2B7B43E14BF@localhost>,<2962401.WRRoYlXkRr@flatron> <60BA5429A0E1584BA3633194F6F993B502B21362@NA-MBX-03.mgc.mentorg.com>
In-Reply-To: <60BA5429A0E1584BA3633194F6F993B502B21362@NA-MBX-03.mgc.mentorg.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 12:59 PM, Chaiken, Alison wrote:
> Grant Likely wrote:
>> Another thing discussed is that we need to start validating DT schema with an extension to dtc.
> 
> Is there a schema out there in the wild that exemplifies what you mean?
> 
>> Tomasz Figa has volunteered to do this work and has support from his employer
> 
> That's great news.
> 
>> to have is that the DT schema will get checked as part of the dts build
>> process so that any DT file that doesn't match the documented schema
>> will get flagged, and that the schema files will be human readable and
>> will double as documentation.
> 
> No doubt DTS files are already the best documentation available for many targets.

A nit here:

The DTS files document what HW modules are present on a board, and
various associated parameters.

The bindings describe the format of those DTS files.

The validation here is ensuring that the DTS files are actually written
in a format that matches what the binding definition requires.

So, the issue isn't really documentation of the HW, but rather
documentation of the required DT format, and validating that the DTS
matches that.
