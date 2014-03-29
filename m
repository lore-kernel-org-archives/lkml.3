Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaC2BnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 21:43:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42222 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaC2Bm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 21:42:59 -0400
Date: Fri, 28 Mar 2014 21:42:54 -0400 (EDT)
Message-Id: <20140328.214254.1620280677250220442.davem@davemloft.net>
To: teg@jklm.no
Cc: dh.herrmann@gmail.com, netdev@vger.kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] Provide netdev naming-policy via sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAG-2HqVQ-MAZgsZAkykvVtbtYgDA3bfJA5rEqpdX5vBqPTjLJg@mail.gmail.com>
References: <CAG-2HqVJPrTWXtuvDkU6MvfNj0MXfNuBMmdoKWtSd5kToZ3mMQ@mail.gmail.com>
	<20140328.172107.16072208664321602.davem@davemloft.net>
	<CAG-2HqVQ-MAZgsZAkykvVtbtYgDA3bfJA5rEqpdX5vBqPTjLJg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Mar 2014 18:42:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Fri, 28 Mar 2014 23:39:57 +0100

> You mean coordinate with each other in userspace? If so, I still don't
> see how this can ever be anything else than fragile. It will depend on
> each userspace component actually opting in to whatever scheme we
> devise, and does so correctly.

Isn't that essentially what dbus is?

A way for seperate userland components to coordinate their
activities?

I just simply don't like all of these ramdom keys getting
added all over the place to guide udev behavior wrt. some
other entity.
