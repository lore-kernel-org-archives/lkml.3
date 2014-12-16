Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaLPSJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:09:43 -0500
Received: from tex.lwn.net ([70.33.254.29]:54016 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaLPSJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:09:42 -0500
Date: Tue, 16 Dec 2014 13:09:39 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk,
        computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] Stop maintainer abuse
Message-ID: <20141216130939.166c4369@lwn.net>
In-Reply-To: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 22:09:46 -0800
Kevin Cernekee <cernekee@gmail.com> wrote:

> This patch series amends the kernel development process to reduce the
> load on key maintainers during peak periods, by discouraging the submission
> of non-urgent patches while the merge window is open.

You do understand the irony of posting this during the merge window,
right? :)

In general, I worry about trying to codify things too much just because
different maintainers have different expectations.  As Linus noted, some
maintainers have their work done by the time the merge window starts and
can take patches just fine — until something catches fire, at least.

I'll await a revision taking account the feedback you've gotten, just
adding my own suggestion to phrase things as guidelines rather than
hard-and-fast rules.

Thanks,

jon
