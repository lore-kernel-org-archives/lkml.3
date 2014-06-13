Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaFMO2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:28:36 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43203 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaFMO2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <1402642787.4478.5.camel@jlt4.sipsolutions.net>
References: <20140612.121445.484288603919840829.davem@davemloft.net>
	<CA+55aFy=CThoSKAJ6J3Jt-SJDkiGzwg=5tdF7_g+vyTEoPFzMQ@mail.gmail.com>
	<1402642787.4478.5.camel@jlt4.sipsolutions.net>
Date: Fri, 13 Jun 2014 07:28:33 -0700
X-Google-Sender-Auth: hSma71CMTtzeaX4smaCb8UiMzi4
Message-ID: <CA+55aFw-UTwA0+dmCnqwjSEW244s0CLK4V5vuh2TmLku7A0mDQ@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Tom Herbert <therbert@google.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> is to be believed, then I'm not sure why you think iwlwifi is involved
> though.

Mainly just because I don't see the issue on my desktop, and iwlwifi
is the only network device (apart from looback) on my laptop. And it
does say "hw checksum", so that made me think it's the driver.

But:

> If it's iwlwifi, then maybe that commit broke something with devices
> that don't support checksumming?

that sounds quite possible.

                Linus
