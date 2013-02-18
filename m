Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3BRSfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:35:40 -0500
Received: from mx1.imag.fr ([129.88.30.5]:43763 "EHLO shiva.imag.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab3BRSfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:35:38 -0500
From: Matthieu Moy <Matthieu.Moy@grenoble-inp.fr>
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.8.2-rc0
References: <7vk3q6e94s.fsf@alter.siamese.dyndns.org>
Date: Mon, 18 Feb 2013 19:35:28 +0100
In-Reply-To: <7vk3q6e94s.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
	message of "Sun, 17 Feb 2013 16:52:19 -0800")
Message-ID: <vpq4nh9v5an.fsf@grenoble-inp.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (shiva.imag.fr [129.88.30.5]); Mon, 18 Feb 2013 19:35:27 +0100 (CET)
X-IMAG-MailScanner-Information: Please contact MI2S MIM  for more information
X-MailScanner-ID: r1IIZR2Y001732
X-IMAG-MailScanner: Found to be clean
X-IMAG-MailScanner-SpamCheck: 
X-IMAG-MailScanner-From: matthieu.moy@grenoble-inp.fr
MailScanner-NULL-Check: 1361817330.90879@G+P747OSOFDj+BbLePvLQA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Git v1.8.2 Release Notes (draft)
> ========================
>
> Backward compatibility notes
> ----------------------------
>
> In the upcoming major release (tentatively called 1.8.2), we will
> change the behavior of the "git push" command.
>
> When "git push [$there]" does not say what to push, we have used the
> traditional "matching" semantics so far (all your branches were sent
> to the remote as long as there already are branches of the same name
> over there).  We will use the "simple" semantics

I don't understand: wasn't this supposed to happen in Git 2.0? Did you
mean "In the upcoming major release (tentatively called *2.0*)"?

Also, you may want to mention the argumentless "git add -u" change too.
It currently has an item below, but this is a future
backward-incompatible change so it may deserve to appear in this section
too.

-- 
Matthieu Moy
http://www-verimag.imag.fr/~moy/
