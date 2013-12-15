Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3LODe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:34:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53277 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LODez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:34:55 -0500
Date: Sat, 14 Dec 2013 22:34:53 -0500 (EST)
Message-Id: <20131214.223453.1858856767733226007.davem@davemloft.net>
To: lists@nerdbynature.de
Cc: schwab@linux-m68k.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        agraf@suse.de
Subject: Re: 3.13-rc1: eth0 hw csum failure on powerpc (bisected)
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.11.1312141622230.25690@trent.utfs.org>
References: <alpine.DEB.2.11.1311301314220.31521__48727.6146108799$1385846242$gmane$org@trent.utfs.org>
	<87vbz9pmud.fsf@igel.home>
	<alpine.DEB.2.11.1312141622230.25690@trent.utfs.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 14 Dec 2013 19:34:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Kujau <lists@nerdbynature.de>
Date: Sat, 14 Dec 2013 16:40:39 -0800 (PST)

> And sure enough, today's 3.13-rc3 with only that commit reverted boots 
> just fine on this PowerBook G4 system.

It's reverted in my 'net' tree, that tree simple hasn't been pushed to
Linus just yet, please be patient.
