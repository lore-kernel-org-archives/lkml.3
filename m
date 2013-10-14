Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3JNRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:16:58 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57106 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab3JNRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131014170741.GA4351@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	<1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
	<20131011152451.GF5925@pd.tnic>
	<20131014031633.GA12189@gchen.bj.intel.com>
	<20131014102635.GC4009@pd.tnic>
	<CA+8MBbJ+mOWhZR5d8wP4x_ncgumGOANziOGmDBzj0QdbPSDH0w@mail.gmail.com>
	<20131014170741.GA4351@pd.tnic>
Date: Mon, 14 Oct 2013 10:16:55 -0700
Message-ID: <CA+8MBbJhtTyPE+NON1=7AQw9FSM5B83Z-TDPNrwnu-8RbS6E=w@mail.gmail.com>
Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 10:07 AM, Borislav Petkov <bp@alien8.de> wrote:
> Ok, then. How about a reg/dereg functionality, something like what I did
> in drivers/edac/mce_amd.c, near the top? We're basically handing down a
> proper function pointer to call and at module unload time we clear it.

Yes - register and unregister functions would be better than

> exporting a naked function pointer.

-Tony
