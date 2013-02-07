Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab3BGBRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:17:12 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:50435 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3BGBRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:17:09 -0500
Date: Thu, 7 Feb 2013 01:46:35 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?utf-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.8-rc] regression: NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
Message-ID: <20130207004635.GA4025@electric-eye.fr.zoreil.com>
References: <CADDKRnBqxSwC7HUP_aN1QELrv2+7jnncXj7EP0Pqv8E8FFTpPw@mail.gmail.com> <20130105093718.GA938@electric-eye.fr.zoreil.com> <CADDKRnBCrDz2X=5qpGE+r92ZFX5cA+jnSGt3wS8TR0RE8hi1HA@mail.gmail.com> <20130105165735.GB4906@electric-eye.fr.zoreil.com> <CADDKRnCkDS5rMSSi12ti5PV_RSP6s3S15YOJz8b98ehcsyKaOA@mail.gmail.com> <CADDKRnACHgBOmw0qLE4zVzhq=Yw-1AYJ-JW0muxRCR3jZ=VoUQ@mail.gmail.com> <CADDKRnAHJAZBittLCFxjgWa1AWKxD7a4hn4v=xvax=ergkKjxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDKRnAHJAZBittLCFxjgWa1AWKxD7a4hn4v=xvax=ergkKjxA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörg Otte <jrg.otte@gmail.com> :
[...]
> To Summarize: Two net-regressions where introduced in v3.8 (driver r8169):
> 
> 1) NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> was introduced by commit
> e0c075577965d1c01b30038d38bf637b027a1df3
> ("r8169: enable ALDPS for power saving")

Hayes Wang <hayeswang@realtek.com> authored it. You should ask him
why commit e0c075577965d1c01b30038d38bf637b027a1df3 sometimes chokes
with the 8168evl. 

And you can ask him if there is a chance that the non-8168evl that are
handled by the patch (mis-)behave the same too.

-- 
Ueimor
