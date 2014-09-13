Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaIMMwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 08:52:55 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36226 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaIMMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 08:52:53 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 13 Sep 2014 14:52:52 +0200
Message-ID: <CA+icZUW8vHj9_L-4WD0FR6mUTWW621T5O-Cd=fSJ_UoPX0BQUg@mail.gmail.com>
Subject: linux-3.16.y: acpi-battery fixes
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I hoped the acpi-fixes from [1] (especially [2]) would fix my shown
"85% battery available", but a Ubuntu/trusty kernel reports the same
(battery defect?).
The 2nd revert is applicable, the 1st not, both are labeled with 3.16+.

Wanna pick them or have it already on your to-do?

Thanks.

Regards,
- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=acpi-battery
[2] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=acpi-battery&id=508b3c677601797f2d51df3df5caa436dd235cb9
