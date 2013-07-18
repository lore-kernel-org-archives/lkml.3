Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3GRDu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:50:28 -0400
Received: from science.horizon.com ([71.41.210.146]:57747 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756708Ab3GRDu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:50:27 -0400
Date: 17 Jul 2013 23:50:26 -0400
Message-ID: <20130718035026.8126.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: tglx@linutronix.de
Subject: Re: [ 00/19] 3.10.1-stable review
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you can point me to a single instance of Linus "abusing" someone
> who is not one of his trusted persons, who really should be able to
> deal with that, or someone who did not provoke him to go into rant
> mode, then I'm all on your side.

Well, the one that comes to mind is Alan Cox and the TTY driver in
2009.

And I still have to agree with his point about Linus's more absolute
pronouncements on user-space regressions: taken literally, they mean
that breaking rootkits is not okay.

Here's the thread if anyonw would like to judge "who started it":

http://marc.info/?t=124870111900001


That said, I strongly agree with this point:
> Linus simply has to trusts his top level maintainers, because he
> cannot review, audit and check 10k patches which flow into his tree
> every merge window himself.
>
> So if he finds out that someone who has his ultimate trust sends him a
> pile of crap, he tells that person in his own unmisunderstandable way
> that he's not amused.
