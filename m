Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934690Ab3BNOjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:39:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab3BNOjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:39:24 -0500
Date: Thu, 14 Feb 2013 15:39:05 +0100
From: Borislav Petkov <bp@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130214143905.GC5700@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <3066730.6MVSAfNyye@vostro.rjw.lan>
 <20130131131034.GF4926@pd.tnic>
 <2293454.v8QRHr8txR@vostro.rjw.lan>
 <20130203144656.GB5844@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130203144656.GB5844@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 03:46:56PM +0100, Borislav Petkov wrote:
> On Sun, Feb 03, 2013 at 12:04:46AM +0100, Rafael J. Wysocki wrote:
> > The [2/5] is at: https://patchwork.kernel.org/patch/2001211/
> > 
> > The other two are attached.  I suppose the ordering doesn't matter.
> 
> Ok, the eth link cable hotplugging issue seems fixed, plugging and
> unplugging the cable works as expected.

Q: what happened to those, are they going upstream for 3.9 or are you
sending them now for 3.8?

They fix at least the cable hotplugging issue so at least one thing is
covered.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
