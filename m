Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaAYKDM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 05:03:12 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62920 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaAYKDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 05:03:10 -0500
MIME-Version: 1.0
Date: Sat, 25 Jan 2014 11:03:09 +0100
Message-ID: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com>
Subject: [kernel 3.13.0-06058-g2d08cd0] Strange ACPI error messages
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 3.13.0-06058-g2d08cd0 displays following errors on the console:

ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
ACPI: \_PR_.CPU7: failed to get CPU APIC ID.

I don't have CPUs 4..7! Error messages regarding not existing
CPUs should not be displayed.
kernel 3.13.0-05617-g3aacd62 and before did'nt show this messages.

This is a regression. I never saw this messages before.

Processor model: Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
$ cat /proc/cpuinfo | grep processor
processor       : 0
processor       : 1
processor       : 2
processor       : 3


Jörg
