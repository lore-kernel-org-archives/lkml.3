Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab3BOJQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:16:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48962 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab3BOJQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:16:52 -0500
Date: Fri, 15 Feb 2013 10:16:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiri Slaby <jslaby@suse.cz>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130215091641.GA14387@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	x86@kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <20130129202848.GE25415@pd.tnic>
 <3066730.6MVSAfNyye@vostro.rjw.lan>
 <20130131131034.GF4926@pd.tnic>
 <2293454.v8QRHr8txR@vostro.rjw.lan>
 <20130203144656.GB5844@pd.tnic>
 <20130214143905.GC5700@pd.tnic>
 <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
 <20130214191234.GH5700@pd.tnic>
 <511DF7B4.8060504@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <511DF7B4.8060504@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:54:12PM +0400, Konstantin Khlebnikov wrote:
> >* https://patchwork.kernel.org/patch/2001211/ (e1000e: fix pci device enable
> >counter balance)
> 
> please use this instead:
> 
> [PATCH v2 1/7] e1000e: fix pci-device enable-counter balance
> https://lkml.org/lkml/2013/2/4/190
> 
> from v2 patchset: https://lkml.org/lkml/2013/2/4/185

So it looks Bjorn has taken most of them and the e1000e one will go
through the e1000e maintainers. I'll test after the merge window is
done.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
