Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaHCEGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 00:06:45 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56328 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaHCEGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 00:06:43 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: pull request: wireless-next 2014-08-01
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140802.193939.2179004210212543536.davem@davemloft.net>
Date: Sat, 2 Aug 2014 21:06:49 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C1E000CB-3DC7-458D-B249-8EE08A8072DD@holtmann.org>
References: <20140801165738.GA26953@tuxdriver.com> <20140802.193939.2179004210212543536.davem@davemloft.net>
To: "David S. Miller" <davem@davemloft.net>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

>> Please pull this last(?) batch of wireless change intended for the
>> 3.17 stream...
> 
> When I pull this I get tons of conflicts for:
> 
> CONFLICT (content): Merge conflict in net/6lowpan/iphc.c
> 
> I don't feel comfortable fixing these up, where are they coming
> from?

they are coding style fixes to bring net/6lowpan/ in sync with net subsystem coding style. That code is still a bit outdated. I took a first stab at fixing the obvious mistakes.

Regards

Marcel

