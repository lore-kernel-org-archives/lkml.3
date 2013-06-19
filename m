Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935118Ab3FSXHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:07:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43413 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FSXHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:07:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Brown, Len" <len.brown@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: Re: [GIT PULL] Some error injection fixes to queue for 3.11
Date: Thu, 20 Jun 2013 01:17 +0200
Message-ID: <1565630.1FKRuXAmOU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C94838515269@FMSMSX106.amr.corp.intel.com>
References: <51b20612239358173f@agluck-desk.sc.intel.com> <3908561D78D1C84285E8C5FCA982C28F2DA87F71@ORSMSX106.amr.corp.intel.com> <1A7043D5F58CCB44A599DFD55ED4C94838515269@FMSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 05:01:52 PM Brown, Len wrote:
> > >> Pulled, thanks Tony!
> > >>
> > >> Len, are you fine with this route [tip:x86/ras tree] for the
> > >> drivers/acpi/apei/einj.c changes?
> > >
> > > Yes, the RAS guys basically own that code.
> > 
> > These patches also got picked up by Rafael and are in his ACPI tree
> > too.  I think the patches were applied identically, so there should not
> > be any merge conflicts when this all comes back together in the 3.11
> > merge window.
> > 
> > Rafael already had a chat about who will take future apei changes
> > so that we won't have this happen again.
> 
> I think the only real problem with being in two places at once
> is if the patches _change_.   When that happens, you need to
> get them _both_ changed, else merge conflict happens at the worst time.

I dropped the APEI patches from my tree.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
