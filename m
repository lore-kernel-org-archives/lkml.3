Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3JNOi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:38:59 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.169]:12011 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab3JNOi6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:38:58 -0400
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-15.tower-38.messagelabs.com!1381761535!1327343!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH V1] new API regmap_multi_reg_write() definition
Thread-Topic: [PATCH V1] new API regmap_multi_reg_write() definition
Thread-Index: AQHOxpAvtnFSWmpW+kamOXXn2a8HhZn0MaUAgAAWwfA=
Date: Mon, 14 Oct 2013 14:38:54 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB516FC73493@NB-EX-MBX02.diasemi.com>
References: <201310111442.r9BEgxmJ029386@swsrvapps-02.lan>
 <20131014141500.GA2443@sirena.org.uk>
In-Reply-To: <20131014141500.GA2443@sirena.org.uk>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.104]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 14 October 2013 15:15
> To: Opensource [Anthony Olech]
> Cc: Greg Kroah-Hartman; LKML; David Dajun Chen
> Subject: Re: [PATCH V1] new API regmap_multi_reg_write() definition
> 
> On Fri, Oct 11, 2013 at 03:31:11PM +0100, Anthony Olech wrote:
> > New API regmap_multi_reg_write() is defined that allows a set of
> > reg,val pairs to be written to a I2C client device as one block
> > transfer from the point of view of a single I2C master system.
> 
> Applied, thanks.  I'll also push out a tag "multi-write" that other subsystems
> can pull to start using the new API prior to it hitting Linus' tree.
> 
> As well as implementing the feature for your devices it would be good to
> refactor the code so it's implemented inside an internal version of the
> function so that things like patch application can be implemented in terms of
> this - that way they'll benefit from any work done here.

I will work on that basis, but I expect a couple of iterations as there is room
for me to have misunderstood you.

Thanks

Tony Olech
