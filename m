Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3GHDKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 23:10:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33189 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3GHDKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 23:10:45 -0400
Date: Sun, 07 Jul 2013 20:14:49 -0700 (PDT)
Message-Id: <20130707.201449.1176672898198722699.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eliezer.tamir@linux.intel.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFyvZAQbaEyq5atQbTjHTz_hodzhWKX_7SRL8nq+yBA14A@mail.gmail.com>
References: <20130707.132133.1335860703202153192.davem@davemloft.net>
	<CA+55aFzgBXwye=ebPmEDN_6yqdKA6ZaD9hSUzbFjSacC_v3y5g@mail.gmail.com>
	<CA+55aFyvZAQbaEyq5atQbTjHTz_hodzhWKX_7SRL8nq+yBA14A@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Jul 2013 15:33:31 -0700

> End result: I think the code is salvageable and people who want this
> kind of busy-looping can have it. But I really don't want to merge it
> as-is. I think it was badly done, I think it was badly documented, and
> I think somebody over-sold the feature by emphasizing the upsides and
> not the problems.

Fair enough, Eliezer, please address all of Linus's feedback.

It's holding the entire net-next merge up.

Thanks.
