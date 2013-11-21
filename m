Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3KUVdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:33:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55126 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753742Ab3KUVdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:33:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Rhyland Klein <rklein@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] net: rfkill: gpio: convert to descriptor-based GPIO interface
Date: Thu, 21 Nov 2013 22:46:28 +0100
Message-ID: <1735877.0KPLyChZ35@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131121172217.GE2281@intel.com>
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com> <528E3D5E.20907@nvidia.com> <20131121172217.GE2281@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 07:22:17 PM Mika Westerberg wrote:
> On Thu, Nov 21, 2013 at 12:05:34PM -0500, Rhyland Klein wrote:
> > This seems like a reasonable patch, and likely a good way to go. I don't
> > have a AC100 to test this with though, so I can't verify this
> > personally. Also, would the paz00 patch become a dependency of this
> > patchset? Mika, maybe you can therefore include a patch for paz00 in
> > your patchset?
> 
> Sure I can, if everyone is OK with that.

No objections from me.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
