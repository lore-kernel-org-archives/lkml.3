Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3FNWOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:14:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37771 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3FNWOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:14:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Lu, Aaron" <aaron.lu@intel.com>
Subject: Re: [PATCH 0/5] ACPI / scan: Make it possible to use the container hotplug with other scan handlers
Date: Sat, 15 Jun 2013 00:23:52 +0200
Message-ID: <3168584.RRBYoY5UXf@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA7C18E@ORSMSX106.amr.corp.intel.com>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan> <1371162234.21540.43.camel@misato.fc.hp.com> <3908561D78D1C84285E8C5FCA982C28F2DA7C18E@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 06:01:41 PM Luck, Tony wrote:
> >> Tony promised me to test those patches on his box, so we'll know for sure
> >> in a while.
> 
> Tested this series - and the box boots just fine with no unexpected messages.

Thanks!

> But I should note that this box doesn't have anything that is hot pluggable, so I
> couldn't test hotplug (which seems to be deeply involved with things that this
> patch is touching).
> 
> Of course that means that I haven't been testing hotplug - so it might have been
> broken for years and I'd never have noticed.

Can you please just test patch [5/5] alone without patches [1-4/5]?  We believe
that this should work too and if that's the case, we'll only need that patch
and a reworked [1/5].

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
