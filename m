Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3BSHUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:20:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47196 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755273Ab3BSHUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:20:44 -0500
Message-ID: <1361258443.5920.7.camel@joe-AO722>
Subject: Re: [PATCH v4 6/6] Input: Add ChromeOS EC keyboard driver
From: Joe Perches <joe@perches.com>
To: Simon Glass <sjg@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Mike A. Chan" <mikechan@google.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Tom Keel <thomas.keel@intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Date: Mon, 18 Feb 2013 23:20:43 -0800
In-Reply-To: <CAPnjgZ3Y88uwrwF7M7-EijA3N8y_jgbcOBeSNtM6T6iG8hW0RQ@mail.gmail.com>
References: <1360988172-15380-1-git-send-email-sjg@chromium.org>
	 <1360988172-15380-7-git-send-email-sjg@chromium.org>
	 <20130216204954.GA22044@core.coreip.homeip.net>
	 <CAPnjgZ3Y88uwrwF7M7-EijA3N8y_jgbcOBeSNtM6T6iG8hW0RQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 20:13 -0800, Simon Glass wrote:
> On Sat, Feb 16, 2013 at 12:49 PM, Dmitry Torokhov
> > On Fri, Feb 15, 2013 at 08:16:12PM -0800, Simon Glass wrote:
> >> +     for (row = 0; row < ckdev->rows; row++) {
> >> +             if (cros_ec_keyb_row_has_ghosting(ckdev, buf, row))
> >> +                     return true;
> >> +     }
> >
> > No need for curly braces here. I would not care if not for below.
> 
> OK I dont't think I even knew about that rule. Actually, what is that rule?

There is no rule, uses with and without braces
exist in about similar numbers in the kernel.

Both are used ~2000 times.

Newer uses more commonly have braces and I think
using braces is a better style.


