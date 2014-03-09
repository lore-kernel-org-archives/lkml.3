Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaCIQM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 12:12:59 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57487 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaCIQM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 12:12:57 -0400
MIME-Version: 1.0
Date: Sun, 9 Mar 2014 17:12:56 +0100
Message-ID: <CADDKRnCTBiGC2fkd1Utp7BY7vjORcHh4O9GgqfMP7iDfFkNKuw@mail.gmail.com>
Subject: [regression] linux-3.14.0-rc5-.. kernel does not switch power off
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On shutdown power is not switched off. The harddisk is already down.
Reboot is working.

Last known good kernel is: 3.14.0-rc5-00265-gb01d4e6
First known bad kernel is: 3.14.0-rc5-00287-gca62eec

FUJITSU LIFEBOOK AH532/FJNBB1C, BIOS Version 1.09 05/22/2012

Jörg
