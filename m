Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaDOOFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:05:17 -0400
Received: from mano-163-35-shared.jabatus.fr ([109.234.163.35]:35499 "EHLO
	mano-163-35-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbaDOOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:05:13 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 912D48F632D4.A1A28
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3776.5040907@manux.info>
Date: Tue, 15 Apr 2014 15:43:18 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][11/11][MANUX] Suggestion : /proc files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, a second suggestion : in /proc, besides the pids and the /proc/self
symlink, there are several files that have a length of 0 (according to
stat(2)), but actually have a non-empty content. What about making these
files character-mode device files? I mean, a file whose content is
virtual an whose size is unknown at stat(2)-time, this seems to
correspond more closely to character-mode files that to regular ones.

That's just an idea that came to me, I've not tried it myself, and
perhaps there are compatibility considerations that prevent such a
modification. But even if there is this problem, this doesn't precludes
making any future file in this way. What do you think about it?

Anyways, that was it. Thanks for your attention, and happy hacking!

Emmanuel
