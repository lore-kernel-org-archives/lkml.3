Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab3CAOdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:33:06 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:56149 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3CAOdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:33:04 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 1 Mar 2013 15:33:02 +0100
Message-ID: <CA+icZUWHK-=gW_aLH-YsYKdwVUZBhmyOGACjY3MUzH+pL1eg7A@mail.gmail.com>
Subject: Re: [PATCH] libata-acpi.c: fix copy and paste mistake in ata_acpi_register_power_resource
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original posting see [1].

Good catch!

Latest Linux-Next (next-20130301) is also affected!

The patch can be easily grabbed from [2].

Sander pointed to the mismatch in [3].

- Sedat -

[1] http://marc.info/?l=linux-kernel&m=136213666529000&w=2
[2] https://patchwork.kernel.org/patch/2200901/
[3] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=bc9b6407bd6df3ab7189e5622816bbc11ae9d2d8#patch5
