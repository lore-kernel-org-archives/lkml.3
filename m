Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbaLEBRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:17:43 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59534 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbaLEBRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:17:40 -0500
MIME-Version: 1.0
Date: Fri, 5 Dec 2014 02:17:39 +0100
X-Google-Sender-Auth: ISk2y8lyti0B_e4iIrwhOmNSVdg
Message-ID: <CAJZ5v0ikkZ9LMFzMoj854nkN9Kno9FqoKffGYh8nJzoQ3GOyWw@mail.gmail.com>
Subject: [GIT PULL] ACPI backlight regression fix for 3.18-rc8
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.18-rc8

to receive an ACPI backlight fix for v3.18-rc8 (or for final 3.18 if
there's no -rc8) as commit 35d0565b95547ec12d025dc9b1394f22968d113d

 ACPI / video: update condition to check if device is in _DOD list

on top of commit 009d0431c3914de64666bec0d350e54fdd59df6a

 Linux 3.18-rc7

This is a simple fix for an ACPI backlight regression introduced by
a recent commit that overlooked a corner case which should have been
taken into account.

Thanks!

---------------

Aaron Lu (1):
      ACPI / video: update condition to check if device is in _DOD list

---------------

 drivers/acpi/video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
