Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaLRTEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:04:13 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60323 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLRTEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:04:12 -0500
Date: Thu, 18 Dec 2014 22:04:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Latest kernel build problem in arch/x86/ia32/audit.c
Message-ID: <20141218190409.GN9435@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! Being trying to build latest repo (2dbfca5a181973558277b28b1f4c36362291f5e0)
and ended up in

  CC      arch/x86/ia32/audit.o
arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
  case __NR_execveat:
       ^
arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [arch/x86/ia32/audit.o] Error 1
make[1]: *** [arch/x86/ia32] Error 2
make: *** [arch/x86] Error 2
make: *** Waiting for unfinished jobs....

The kernel's config at https://gist.github.com/cyrillos/cd9749c4205fed698f13
Because it's middle of merge window I guess it's not anyhow important and I'll
try take a look myself tomorrow or on weekend, but just for info.

	Cyrill
