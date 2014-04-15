Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaDOOFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:05:09 -0400
Received: from mano-163-21-shared.jabatus.fr ([109.234.163.21]:44335 "EHLO
	mano-163-21-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbaDOOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:05:07 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 2300B8F60B0E.AE677
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3745.6000000@manux.info>
Date: Tue, 15 Apr 2014 15:42:29 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][0/11][MANUX] Kernel compatibility : introduction
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, World^W LKML-ers!

I've written a little clone of the Linux kernel from scratch
(http://www.manux.info). It only runs on x86-32, is far smaller and far
less advanced, and some syscalls are unimplemented (and many
functionnalities are lacking), but it's otherwise binarily compatible
with Linux; and I would like to keep it this way.

However, since both its internal architecture and its userspace
conception are very different, I've had to make some adaptations, and I
would like to ask you some question about them in order to avoid future
trouble. Since they relate to very different areas, I'm going to post
them in separate emails after this one.

Since I have had only one user beside myself so far, if there's
something that you think is problematic, I can make changes, and even
break my own binary compatibility if needed (although I would obviously
prefer not to); just tell me about it.

Thank you for your attention!

Emmanuel Colbus

P.S. : I read LKML through hypermail, so you don't need to keep me CC'd,
but if you do, please keep the [MANUX] tag in the subject, otherwise my
antispam will reject your mail.
