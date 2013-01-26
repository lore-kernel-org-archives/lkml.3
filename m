Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3AZNfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:35:19 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:59910 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3AZNfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:35:16 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] Include kernel config by default
Date: Sat, 26 Jan 2013 14:34:25 +0100
Message-Id: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've seen too many systems where the config to build the used kernel got
lost and people were unable to diagnose problems or to rebuild a modified
or updated kernel. It's a subject which worries me since several years.

Therefor I finally prepared the following patch(es) to include the config
by default, make it by default accessible through /proc/config.gz, to
hide the option to not include the config below "embedded" and to remove all
now unnecessary IKCONFIG_* options from 174 defconfigs (almost all of them
enabled those options explicit).

I've already posted that two times before
(https://lkml.org/lkml/2012/7/25/2 and https://lkml.org/lkml/2012/10/18/132)
without even getting a single response. So I don't know if it's a totally
foolish idea, if nobody is interested, or if the previous patches just weren't
seen by anybody.

I've now added the maintainers of the two large architectures (x86 and arm), the
master himself and a few other people to cc (sorry if I've missed any important
person), and I made the subject more clearly.

Maybe this will provoke at least a single response. ;)

Regards,

Alexander

