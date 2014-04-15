Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaDONuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:50:11 -0400
Received: from mano-163-42-shared.jabatus.fr ([109.234.163.42]:34599 "EHLO
	mano-163-42-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbaDONuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:50:07 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: D23E08F61C6D.A1D36
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D375E.7070308@manux.info>
Date: Tue, 15 Apr 2014 15:42:54 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][4/11][MANUX] Kernel compatibility : ioctl(2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing with syscalls, I would like to indicate you a modification
I've done with regards to ioctl's. The thing is, I have had the need for
ioctl's that return *file descriptors*, instead of standard return codes.

To distinguish them from the others, I have given them identifiers that
are superior or equal to 0x80000000 (when unsigned, negative when
signed).  Of course, Linux will reject them, but that's fine, these are
low-level OS-dependant ioctl's that aren't supposed to be compatible.

Do you have any objection or remark regarding this?

Thanks!

Emmanuel
