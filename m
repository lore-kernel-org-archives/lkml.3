Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaE2U3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:29:24 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:56728 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbaE2U3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:29:23 -0400
Date: Thu, 29 May 2014 23:28:08 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Jonas Bonn <jonas@southpole.se>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux <linux@openrisc.net>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] openrisc: irq: use irqchip framework
Message-ID: <20140529202806.GA9387@chokladfabriken.org>
References: <1401136302-27654-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <CAMuHMdUUqaRP2M0hPh5k0nPp1a_t0W98Vc_4zAQMjGYZZOPd8w@mail.gmail.com>
 <53843508.7060007@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53843508.7060007@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 08:47:36AM +0200, Jonas Bonn wrote:
> On 05/26/2014 10:52 PM, Geert Uytterhoeven wrote:
> > CC devicetree for the bindings
> > 
> > On Mon, May 26, 2014 at 10:31 PM, Stefan Kristiansson
> > <stefan.kristiansson@saunalahti.fi> wrote:
> >> +++ b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
> >> @@ -0,0 +1,23 @@
> >> +OpenRISC 1000 Programmable Interrupt Controller
> >> +
> >> +Required properties:
> >> +
> >> +- compatible : should be "opencores,or1k-pic-level" for variants with
> >> +  level triggered interrupt lines, "opencores,or1k-pic-edge" for variants with
> >> +  edge triggered interrupt lines or "opencores,or1200-pic" for machines
> >> +  with the non-spec compliant or1200 type implementation.
> >> +
> >> +  "opencores,or1k-pic" is also provided as an alias to "opencores,or1200-pic",
> >> +  but this is only for backwards compatibility.
> 
> I still think this identifier needs to be versioned.  Use the same
> version number as we have on the cpu identifier since the OR1200 PIC
> hasn't changed since then; i.e. opencores,or1200-pic-rtlsvnXYZ.
> 

I can change that if you *really* insist on it...
But I don't understand the purpose of the versioning here,
there will never be any other or1200-pic version than the one that currently
exists, so IMO "or1200" should be enough versioning information.

Stefan
