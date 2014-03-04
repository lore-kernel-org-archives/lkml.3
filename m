Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbaCDV0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:26:41 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:42754 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaCDV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:26:38 -0500
MIME-Version: 1.0
Date: Tue, 4 Mar 2014 22:26:37 +0100
Message-ID: <CA+MoWDrTNtAHKsiBHz=W4=eJRO=m9EK_HZ7zLxb=4fg5riUQeg@mail.gmail.com>
Subject: My Kernel bug is celebrating 2 years. Can you help me fix it?
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have reported a bug more than two years ago and it is still
affecting me. The bug report gives some information:

https://bugzilla.redhat.com/show_bug.cgi?id=787299

I have tried basic debug instructions from:
https://www.kernel.org/doc/Documentation/power/basic-pm-debugging.txt

And everything works as expected when:
# echo freeze > /sys/power/state
# echo disk > /sys/power/state

I have asked for help for fixing it:
https://lkml.org/lkml/2013/11/1/186

But I don't have a serial port. How can I debug this issue without a
"real" serial port? Or what else can I try? How can I explore the hint
about the problem only happening with VT-d enabled in BIOS? How can I
explore the hint about the problem not happening if the option
nox2apic is passed to the Kernel?

Thank you,

Peter

P.S Yes, it works on Windows.

-- 
Peter
