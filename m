Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaDOOFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:05:21 -0400
Received: from mano-163-30-shared.jabatus.fr ([109.234.163.30]:41919 "EHLO
	mano-163-30-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbaDOOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:05:12 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 10:05:12 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 499FA8F62BB2.A1ADC
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3770.7010806@manux.info>
Date: Tue, 15 Apr 2014 15:43:12 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][9/11][MANUX] Kernel compatibility : ext2's dtime field?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, another question. In ext2, what is the point of the dtime field?
Personaly, I'm never setting it, because, well, if an inode is removed,
it's removed, and nobody is supposed to access it again; and anyways,
since no syscall allows seeing it, the dtime seems to me like nothing
but an information leakage. But I doubt you would have put a useless
data in the filesystem, so I'm likely overlooking something; if so, what
is it?
