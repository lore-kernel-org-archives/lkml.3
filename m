Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaAYCAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 21:00:19 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:40978 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaAYCAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 21:00:16 -0500
MIME-Version: 1.0
In-Reply-To: <1390534568.12771.58.camel@rzhang1-mobl4>
References: <1390534568.12771.58.camel@rzhang1-mobl4>
Date: Fri, 24 Jan 2014 18:00:15 -0800
X-Google-Sender-Auth: wdGjV8XiapyxwBbnJGcCMcgniRI
Message-ID: <CA+55aFyPGdJEP3fpZxVqQNp_BtJ3vqqq_0xst_3H8Pf9QV627Q@mail.gmail.com>
Subject: Re: [GIT PULL] Thermal management updates for v3.14-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-devicetree <devicetree@vger.kernel.org>,
        linux-lmsensor <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 7:36 PM, Zhang Rui <rui.zhang@intel.com> wrote:
>
> Please pull from the git repository at
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next
>
> to receive Thermal management updates for v3.14-rc1

This annoys me _enormously_:

  CONFIG_ACPI_INT3403_THERMAL:

  This driver uses ACPI INT3403 device objects. If present, it will
  register each INT3403 thermal sensor as a thermal zone.

This is the "help" text for the new ACPI thermal driver.

WTF?

Really, whoever wrote that "help" text wasn't thinking of helping
users. What the f*ck is an INT3403 device object? Is is common? Where?
Is it a standard? Is it something normal people should expect?

              Linus
