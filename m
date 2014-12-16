Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaLPWTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:19:25 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39860 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLPWTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:19:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141216130939.166c4369@lwn.net>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com> <20141216130939.166c4369@lwn.net>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 16 Dec 2014 14:19:02 -0800
Message-ID: <CAJiQ=7B76vE2ctYd2GK5+_whNnLGKtUY65qkMLdewBqfO7HfPg@mail.gmail.com>
Subject: Re: [RFC 0/4] Stop maintainer abuse
To: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, bp@alien8.de,
        gnomes@lxorguk.ukuu.org.uk, Brian Norris <computersforpeace@gmail.com>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:09 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Sun, 14 Dec 2014 22:09:46 -0800
> Kevin Cernekee <cernekee@gmail.com> wrote:
>
>> This patch series amends the kernel development process to reduce the
>> load on key maintainers during peak periods, by discouraging the submission
>> of non-urgent patches while the merge window is open.
>
> You do understand the irony of posting this during the merge window,
> right? :)

I specifically exempted [RFC] from the rules because these threads are
readily distinguishable from urgent patches.  One could envision
setting up a procmail rule to move all [RFC] and [.*-next] messages
into a "save for later" folder.

> In general, I worry about trying to codify things too much just because
> different maintainers have different expectations.  As Linus noted, some
> maintainers have their work done by the time the merge window starts and
> can take patches just fine — until something catches fire, at least.

Do you think it might make sense to list the (stricter?) patch
acceptance policies in MAINTAINERS?

In the current process, many submitters do not know their maintainer's
policy until they get in trouble for violating it.  This is not a very
efficient way of educating people.  It might work if a submitter is
focusing most of his efforts on a small number of subsystems, with
which he becomes familiar over time.  But it doesn't work if somebody
has to touch many different areas of the kernel just once to e.g. add
support for a new SoC (including its syscon devices, irqchip drivers,
regulators, clocks, buses, and peripherals).
