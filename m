Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaAHAjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:39:43 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14054 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaAHAjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:39:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18KUxTQnBpN4AL3o0/s+lAR
Date: Tue, 7 Jan 2014 16:39:28 -0800
From: Tony Lindgren <tony@atomide.com>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ARM: OMAP: raw read and write endian fix
Message-ID: <20140108003927.GJ5074@atomide.com>
References: <1387822234-11167-1-git-send-email-taras.kondratiuk@linaro.org>
 <CAArO44vC4WKGHSqHX3+Mo5+jcNuyJLkh94+SPd4H+aZYAroYzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAArO44vC4WKGHSqHX3+Mo5+jcNuyJLkh94+SPd4H+aZYAroYzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Taras Kondratiuk <taras.kondratiuk@linaro.org> [131223 10:20]:
> On 23 December 2013 20:10, Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:
> > This series does trivial replacement of __raw_xxx functions with xxx_relaxed
> > endian-neutral variants in 'mach-omap2' and 'plat-omap' directories.
> > Some code here most probably won't be used in BE mode (like debug-leds for
> > OMAP1 boards), but changes are made anyway to remove __raw_xxx() functions
> > completely and simplify future grep'ing for new __raw_xxx() entries.

Sorry for the delay on these, applying into omap-for-v3.14/be.
These are trivial, and it's actually nice that you left out the
assembly related changes as those should be acked by the PM
people in case there are some issues dealing with the ROM code
etc.

Regards,

Tony
