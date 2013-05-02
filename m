Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3EBGl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:41:57 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:58420 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3EBGlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:41:53 -0400
Date: Thu, 2 May 2013 08:41:40 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, hayeswang <hayeswang@realtek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
Message-ID: <20130502064140.GA21494@electric-eye.fr.zoreil.com>
References: <20130501.164755.1859264969403837546.davem@davemloft.net>
 <CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> :
[...]
> Any ideas?

1a9646497b163a8b9da5e70008d809dc91b32855 ("r8169: adjust the flow of hw_start"),
eee3786f7d3134e3edc54c1134511d520dd74285 ("r8169: Modify the method for setting
firmware") and 0427d0152eb3c2c2712afa427dd593c68fc09299
("r8169: Remove firmware code") may play a role on your 8168D setup, either by
themselves or combined with something else.

Expect no sign of life from me until the late end of the european working
hours.

-- 
Ueimor
