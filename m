Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbaDOOAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:00:24 -0400
Received: from mano-163-39-shared.jabatus.fr ([109.234.163.39]:51770 "EHLO
	mano-163-39-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbaDOOAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:00:13 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 10:00:13 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 1B93A8F62817.A139B
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D376D.4080003@manux.info>
Date: Tue, 15 Apr 2014 15:43:09 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][8/11][MANUX] Kernel compatibility : d_off?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, I would like to ask you a few questions about some stuff I've not
fully understood. Let's start with the d_off field in the dirent
structure of the getdents(2) and getdents64(2) syscalls. What is its
meaning?

Personnaly, I've implemented it as documented in the manpage, but
since it doesn't seems to correspond to the actual behaviour of the
Linux kernel, there might be an incompatibility here, so let me know if
this is an issue.
