Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab3HSSsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:48:11 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:52891 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3HSSsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:48:09 -0400
MIME-Version: 1.0
Date: Mon, 19 Aug 2013 20:48:08 +0200
Message-ID: <CA+i8gKKzt3Uf7Bt88=AFyKbdHuqaTqy96nCHTtO=t+4+dhQ0Pw@mail.gmail.com>
Subject: commit 94fc5d9: chromium-sandbox core dumped
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: richard.genoud@gmail.com, viro@zeniv.linux.org.uk,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following commit breaks chromium on my machine:

commit 94fc5d9de5bd757ad46f0d94bc4ebf617c4487f6
Author: Richard Genoud <richard.genoud@gmail.com>
Date:   Mon Aug 19 18:30:31 2013 +0200

    proc: return on proc_readdir error

Chromium breaks with:

[269:269:0819/203839:FATAL:zygote_host_impl_linux.cc(195)] Check
failed: pid_0. Did not find zygote process (using sandbox binary
/usr/lib/chromium/chromium-sandbox)
Aborted (core dumped)

Thanks in advance.
-- Emmanuel
