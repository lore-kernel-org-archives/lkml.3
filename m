Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaHCCjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 22:39:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51084 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHCCjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 22:39:40 -0400
Date: Sat, 02 Aug 2014 19:39:39 -0700 (PDT)
Message-Id: <20140802.193939.2179004210212543536.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-08-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140801165738.GA26953@tuxdriver.com>
References: <20140801165738.GA26953@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 19:39:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 1 Aug 2014 12:57:38 -0400

> Please pull this last(?) batch of wireless change intended for the
> 3.17 stream...

When I pull this I get tons of conflicts for:

CONFLICT (content): Merge conflict in net/6lowpan/iphc.c

I don't feel comfortable fixing these up, where are they coming
from?
