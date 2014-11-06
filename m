Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaKFTaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:30:25 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64409 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKFTaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141104190451.GS1618@lahna.fi.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
	<CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com>
	<20141104082056.GG1618@lahna.fi.intel.com>
	<545912D2.5090708@codeaurora.org>
	<20141104190451.GS1618@lahna.fi.intel.com>
Date: Thu, 6 Nov 2014 20:30:23 +0100
Message-ID: <CACRpkdZOhcUsxC+VTBbpGSKfR7bXJ-WS9MxUb948r0Bvzyz2Mw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Timur Tabi <timur@codeaurora.org>, Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 8:04 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> We still need to account the fact that BIOS is supposed to configure the
> pins in advance. The pinctrl mappings are just for refining that, like
> muxing out the SPI pins instead of GPIOs and so on.

Pinctrl currently has no real way of reading out the state from the
hardware and presenting it as a selected group+function combination,
it only knows what has been selected intrinsically with the system,
so some enhancements may be needed to make pinctrl reflect
the state when booting.

Yours,
Linus Walleij
