Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbaLOM0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:26:25 -0500
Received: from syn.loicp.eu ([176.31.96.212]:60437 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaLOM0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:26:23 -0500
Date: Mon, 15 Dec 2014 13:26:18 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: staging: goldfish: Fix minor coding style
Message-ID: <20141215122618.GA1382@iron>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
 <20141213190705.0faaf119@lxorguk.ukuu.org.uk>
 <20141213212051.GB6979@iron>
 <20141215115147.3d4333e5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141215115147.3d4333e5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:51:47AM +0000, One Thousand Gnomes wrote:
> 
> Depends what you feel confident tackling. An interesting but
> challenging one to look at as a newcomer might be
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=87951
> 
> because it provides you with an example .iso file you can loopback mount
> to see the crash, and the same fixes were done for a similar bug so can
> be seen in the git log to work from.
> 
> commit 410dd3cf4c9b36f27ed4542ee18b1af5e68645a4
> 
> It's predictable, it's repeatable and it can be done crashing a virtual
> machine not a real one. That usually makes things eaiser to fix.
> 
> For something easier perhaps
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=75111
> 
> which just needs the configuration help fixing
> 
> Alan
> 

Hi Alan,

Your answer is greatly appreciated, I'm going to do my best!

-- 
Cheers,
Loïc
