Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaDONzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:55:15 -0400
Received: from mano-163-21-shared.jabatus.fr ([109.234.163.21]:57537 "EHLO
	mano-163-21-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbaDONzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:55:12 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 363AC8F61869.A03FC
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D375B.9070806@manux.info>
Date: Tue, 15 Apr 2014 15:42:51 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][3/11][MANUX] Kernel compatibility : syscall numbers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing the discussion regarding syscalls, I have a question
regarding vector 0x80.

As I mentionned earlier, my OS's internals are very different from
Linux's, thus I have had a need for a few new syscalls. Since I wanted
to avoid any collision with Linux, but I also wanted to keep the
ability to put the syscall table in a single 4096-byte page on 64-bit
computers (on which I hope to run one day), I chose to start taking
syscall number 511, and to progress downwards - currently, I'm using
numbers 511 through 501 included (with a hole at 503, but I'll likely
fill it again in the future).

Is this okay for you? And in this case, if this isn't asking too much,
could you avoid using them for now, to avoid any conflict?

Thank you!

Emmanuel
