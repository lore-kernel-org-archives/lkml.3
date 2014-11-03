Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaKCUYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:24:52 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:48559 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbaKCUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:24:51 -0500
Message-ID: <1415046288.2726.7.camel@sipsolutions.net>
Subject: Re: [RFC v2 1/4] backports: replace CPTCFG prefix for
 CONFIG_BACKPORT
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Date: Mon, 03 Nov 2014 21:24:48 +0100
In-Reply-To: <CAB=NE6V1JViQyKRdEnaK=Ek4HC4qt_mdyrtk8kT_CG=YkxS+6w@mail.gmail.com> (sfid-20141103_212216_214883_B63B5778)
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
	 <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com>
	 <1414741273.3014.3.camel@jlt4.sipsolutions.net>
	 <20141031193408.GA12953@wotan.suse.de>
	 <1414786943.3014.37.camel@jlt4.sipsolutions.net>
	 <CAB=NE6UVca47FyZv54pED3C_1go+-Ra_AbSwW1+=Gj5YWP0GHw@mail.gmail.com>
	 <CAB=NE6U7-TE9Oe_aTvjr4Y1iGALMeRohmx-ekbzmRuzAbbqTTA@mail.gmail.com>
	 <1415043615.2726.4.camel@sipsolutions.net>
	 <CAB=NE6XWWcmRb-3r28obFmChzW1mnynG0LkVDr2-y+QVpq=y9Q@mail.gmail.com>
	 <1415046029.2726.6.camel@sipsolutions.net>
	 <CAB=NE6V1JViQyKRdEnaK=Ek4HC4qt_mdyrtk8kT_CG=YkxS+6w@mail.gmail.com>
	 (sfid-20141103_212216_214883_B63B5778)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 12:21 -0800, Luis R. Rodriguez wrote:

> OK I'll prefix the stuff we copy over with something else then, BPAUTO.

I still want to keep CPTCFG though :)

johannes


