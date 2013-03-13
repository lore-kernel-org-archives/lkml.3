Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3CMFcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:32:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55056 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3CMFcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:32:11 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: RE: [PATCHv3 01/14] mailbox: rename pl320-ipc specific mailbox.h
Thread-Topic: [PATCHv3 01/14] mailbox: rename pl320-ipc specific mailbox.h
Thread-Index: AQHOH5rdpQiXhpN28USwLigRpWbWH5ijURQA//+9t5A=
Date: Wed, 13 Mar 2013 05:31:53 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C504978B9@DLEE11.ent.ti.com>
References: <1363145030-14373-1-git-send-email-s-anna@ti.com>
 <20130313035252.GA1515@kroah.com>
In-Reply-To: <20130313035252.GA1515@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Mar 12, 2013 at 10:23:50PM -0500, Suman Anna wrote:
> > The patch 30058677 "ARM / highbank: add support for pl320 IPC"
> > added a pl320 IPC specific header file as a generic mailbox.h.
> > This file has been renamed appropriately to allow the introduction of
> > the generic mailbox API framework.
> >
> > Signed-off-by: Suman Anna <s-anna@ti.com>
> > Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/cpufreq/highbank-cpufreq.c |  2 +-
> >  drivers/mailbox/pl320-ipc.c        |  2 +-
> >  include/linux/mailbox.h            | 17 -----------------
> >  include/linux/pl320-ipc.h          | 17 +++++++++++++++++
> >  4 files changed, 19 insertions(+), 19 deletions(-)  delete mode
> > 100644 include/linux/mailbox.h  create mode 100644
> > include/linux/pl320-ipc.h
> 
> Why are you sending these To: me?  I'm not the mailbox maintainer, and have
> never handled them before that I can remember.  Who is the maintainer?

Er.. sorry Greg, I have taken the recipient list from the original series posting, but this series should have been directed to the ARM-SoC maintainer. The patches are generalizing the OMAP mailbox driver to add support for ST's mailbox as well,  and moving it to under /drivers/mailbox. The folder is new in 3.9, and the code under this, so far,  has all been for ARM based chips. I guess the maintainer for this folder needs to be sorted out for the long-term.

Regards
Suman
