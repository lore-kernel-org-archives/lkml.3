Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaKRUe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:34:28 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:32957 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaKRUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:34:26 -0500
Date: Tue, 18 Nov 2014 21:32:00 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Carlo Caione <carlo@caione.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: meson: add I2C controller nodes
Message-ID: <20141118203200.GA26363@gmail.com>
References: <1415907123-4318-1-git-send-email-b.galvani@gmail.com>
 <1415907123-4318-4-git-send-email-b.galvani@gmail.com>
 <20141118151927.GG30004@katana>
 <CAOQ7t2Yw5h61xWf2MW11Zsz5_gnv==ihB7Swj=yqcYc=J166gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ7t2Yw5h61xWf2MW11Zsz5_gnv==ihB7Swj=yqcYc=J166gw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 04:29:13PM +0100, Carlo Caione wrote:
> On Tue, Nov 18, 2014 at 4:19 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > On Thu, Nov 13, 2014 at 08:32:03PM +0100, Beniamino Galvani wrote:
> >> Add nodes for I2C controllers A,B,AO, which are available in both
> >> Meson6 and Meson8.
> >>
> >> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> >> ---
> >
> > I usually don't take DTS patches. They should go via arm-soc. Please say
> > so if there are reasons I should take it.
> 
> I'll take them.

Thanks!

Beniamino
