Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3AaNKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:10:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab3AaNKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:10:46 -0500
Date: Thu, 31 Jan 2013 14:10:34 +0100
From: Borislav Petkov <bp@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130131131034.GF4926@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
	x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <20130131070926.GC4926@pd.tnic>
 <510A27C8.3070909@suse.cz>
 <3066730.6MVSAfNyye@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3066730.6MVSAfNyye@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 02:12:58PM +0100, Rafael J. Wysocki wrote:
> Yes, there are two bugs in e1000e, it appears. Konstantin's
> patch [2/5] fixes one of them, but the other one has to be fixed
> differently.
>
> Boris, would you be able to test a couple of e1000e patches for me?

Sure, send them on. You can add 2/5 in the mix too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
