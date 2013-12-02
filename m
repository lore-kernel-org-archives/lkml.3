Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab3LBVaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:30:13 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47441 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3LBVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:30:09 -0500
Date: Mon, 2 Dec 2013 22:30:07 +0100
From: Andreas Mohr <andi@lisas.de>
To: venkata koppula <vmrkoppula@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Andreas Mohr <andi@lisas.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Copying large files eats all of the RAM
Message-ID: <20131202213007.GA3124@rhlx01.hs-esslingen.de>
References: <20131129215616.GA32242@rhlx01.hs-esslingen.de>
 <52992659.5040503@gmail.com>
 <CAKK=TULveq5m2zX9YQS_v3KUp04qV+XME06tEhFx9upHG7D00w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKK=TULveq5m2zX9YQS_v3KUp04qV+XME06tEhFx9upHG7D00w@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 11:59:07AM +0530, venkata koppula wrote:
> Thanks for you replies.
> 
> Yeah, I understand that we need to utilize the resources as much as we
> can. At the same time user should not
> feel that system is slow and user should never wait for the copying
> operation should complete to launch another
> application meanwhile.
> 
> If the user is a system administrator or a programmer, he/she
> understands the problem and will try to tune the kernel
> based on his/her requirements. As an application user(A desktop user
> doesn't worry about the optimizations,
> even doesn't know what it is:)) faster response is important.

I'm afraid you're damn right - standard configuration ought to be pretty
similar to the optimum, without any tuning, given that most people don't
(know to) do manual tuning.
And even in recent times the kernel did not manage to achieve that goal,
for several use cases. But I'm quite certain we're getting closer :)

BTW, a quite likely related and possibly helpful topic is
"[patch 7/9] mm: thrash detection-based file cache sizing" https://lkml.org/lkml/2013/12/2/483

HTH,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
