Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab3KGMzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:55:37 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41927 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956Ab3KGMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:55:36 -0500
X-Sasl-enc: uSQUVXHcsX1Z7345CnPoiuUsRnsdXyTzsXgqGckJwlfA 1383828935
Date: Thu, 7 Nov 2013 10:55:32 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
        Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM audit, seccomp, etc are broken wrt OABI syscalls
Message-ID: <20131107125532.GB3355@khazad-dum.debian.net>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
 <CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
 <20131106004058.GU16735@n2100.arm.linux.org.uk>
 <CALCETrXd7SknNCptTTojBzOo+RNzPwGrgjigVdVeOkGMAtajWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXd7SknNCptTTojBzOo+RNzPwGrgjigVdVeOkGMAtajWg@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Nov 2013, Andy Lutomirski wrote:
> Maybe the thing to do is to put a warning in the config text for
> CONFIG_OABI_COMPAT that describes the problems (malicious userspace
> can confuse syscall auditors, strace, etc.), change the "if in doubt"
> part to N, and disable seccomp filters if CONFIG_OABI_COMPAT.  That
> might even get Debian to change their default.

Bug reported to the Debian BTS: #728975
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=728975

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
