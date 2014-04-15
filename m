Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaDOOAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:00:22 -0400
Received: from mano-163-55-shared.jabatus.fr ([109.234.163.55]:58894 "EHLO
	mano-163-55-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbaDOOAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:00:13 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 7AA438F62607.A0535
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3769.9070309@manux.info>
Date: Tue, 15 Apr 2014 15:43:05 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][7/11][MANUX] Kernel compatibility : capset(2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now another syscall. I recently implemented capabilities, and decided to
use a version number that's different from the one Linux uses.  I guess
that's exactly how I should have done it, but can you confirm me that
this is acceptable?

Also, for your information, I decided to use 64-bit capabilities, in
order to give a possibility to reduce the rights of an unprivileged
software (for example, if a process lacks CAP_USR_CHMOD, it won't be
able to perform a chmod on an existing file). This means I'm not using
the same data structure as you; do you have any objection to it?

Thank you,

Emmanuel
