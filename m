Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3LKQAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:00:21 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40847 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3LKQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:00:16 -0500
Date: Wed, 11 Dec 2013 10:55:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-12-10
Message-ID: <20131211155507.GE7411@tuxdriver.com>
References: <20131210153830.GA1542@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210153830.GA1542@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:38:30PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> More patches to 3.14. Here we have the support for Low Energy Connection
> Oriented Channels (LE CoC). Basically, as the name says, this adds supports
> for connection oriented channels in the same way we already have them for
> BR/EDR connections so profiles/protocols that work on top of BR/EDR can now
> work on LE plus a plenty of new possibilities for LE.
> 
> Please pull. Thanks!!
> 
> 	Gustavo
> 
> ---
> The following changes since commit 201a5929c8c788f9ef53b010065c9ce70c9c06f0:
> 
>   Bluetooth: Remove dead code from SMP encryption function (2013-12-04 11:09:05 -0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 71fb419724fadab4efdf98210aa3fe053bd81d29:
> 
>   Bluetooth: Fix handling of L2CAP Command Reject over LE (2013-12-10 01:15:44 -0800)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
