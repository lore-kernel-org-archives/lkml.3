Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3GDM2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:28:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58215 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3GDM2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:28:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Renninger <trenn@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, rui.zhang@intel.com,
        lenb@kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/3] ACPI: Remove old /proc/acpi/event interface
Date: Thu, 04 Jul 2013 14:37:48 +0200
Message-ID: <1935997.TsJ39x11ul@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1513052.oSjeLTGJqb@skinner.arch.suse.de>
References: <1372855719-34315-1-git-send-email-trenn@suse.de> <1545278.bq6oSR27Gq@vostro.rjw.lan> <1513052.oSjeLTGJqb@skinner.arch.suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 04, 2013 09:49:02 AM Thomas Renninger wrote:
> On Wednesday, July 03, 2013 11:56:27 PM Rafael J. Wysocki wrote:
> > On Wednesday, July 03, 2013 02:48:38 PM Thomas Renninger wrote:
> > > It is quite some time that this one is deprecated.
> > > Get rid of it.
> > > 
> > > If there should really some important user be overseen it could get
> > > reverted and worked on the userspace program first. But it is time to do
> > > something to get rid of this old stuff...
> > 
> > Does this patch depend on the other patches in this series?
> 
> I should have split this up in two submit requests...:
> 
> [PATCH 1/3] x86 microcode: Remove old MICROCODE_OLD_INTERFACE
> is independent from the other two, but
> 
> [PATCH 2/3] ACPI: Remove old /proc/acpi/event interface
> and
> [PATCH 3/3] platform thinkpad: Remove deprecated hotkey_report_mode parameter
> should go in together.

OK

I can take [2/3] and [3/3] for 3.12 if Matthew has no objections.  Matthew?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
