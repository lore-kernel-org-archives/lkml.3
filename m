Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbaGEC70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 22:59:26 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:45011 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaGEC7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 22:59:25 -0400
MIME-Version: 1.0
Date: Fri, 4 Jul 2014 22:59:24 -0400
Message-ID: <CAPDOMVj-++wOH38d4setvfGFdsaMkn8Rzo4-3YajgGkV2A-aug@mail.gmail.com>
Subject: mips: FIX ME message in smp_cmp.c
From: Nick Krause <xerofoify@gmail.com>
To: ralf@linux-mips.org
Cc: paul.burton@imgtec.com, markos.chandras@imgtec.com,
        Leonid.Yegoshin@imgtec.com, Steven.Hill@imgtec.com,
        linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am wondering if in this file, arch/mips/kernel/smp-cmp.c the fix me
message in cmp_smp_finish I can remove the line that the fix me
message states below it or
is this part of the function still needed.
Cheers Nick
