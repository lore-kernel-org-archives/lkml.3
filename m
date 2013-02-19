Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3BSHo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:44:27 -0500
Received: from mx1.imag.fr ([129.88.30.5]:47858 "EHLO shiva.imag.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab3BSHoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:44:25 -0500
From: Matthieu Moy <Matthieu.Moy@grenoble-inp.fr>
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.8.2-rc0
References: <7vk3q6e94s.fsf@alter.siamese.dyndns.org>
	<vpq4nh9v5an.fsf@grenoble-inp.fr>
	<7vobfh8bjc.fsf@alter.siamese.dyndns.org>
	<7vk3q58987.fsf@alter.siamese.dyndns.org>
Date: Tue, 19 Feb 2013 08:44:16 +0100
In-Reply-To: <7vk3q58987.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
	message of "Mon, 18 Feb 2013 15:59:04 -0800")
Message-ID: <vpqliaku4rz.fsf@grenoble-inp.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (shiva.imag.fr [129.88.30.5]); Tue, 19 Feb 2013 08:44:16 +0100 (CET)
X-IMAG-MailScanner-Information: Please contact MI2S MIM  for more information
X-MailScanner-ID: r1J7iGqH007367
X-IMAG-MailScanner: Found to be clean
X-IMAG-MailScanner-SpamCheck: 
X-IMAG-MailScanner-From: matthieu.moy@grenoble-inp.fr
MailScanner-NULL-Check: 1361864661.46103@XhQ8OZ7Kyl0E5NqLQhbCeQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> +At Git 2.0 (not *this* one), we
> +plan to change these commands without pathspec to operate on the
> +entire tree, and training your fingers to type "." will protect you
> +against the future change.

My understanding of the plan was more to forbid argumentless git -u|-A
at Git 2.0 (this is the potentially harmful change), and then to
re-allow it with different semantics later.

But I'm OK with changing directly too, as long as we have warned for
some time before, and will continue to warn after for some time too.

-- 
Matthieu Moy
http://www-verimag.imag.fr/~moy/
