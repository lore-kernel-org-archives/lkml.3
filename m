Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab3GZU2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:28:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50679 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759608Ab3GZU2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:28:37 -0400
Message-ID: <51F2DBDD.8020709@zytor.com>
Date: Fri, 26 Jul 2013 13:28:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
References: <rddfy5e894xuv6d47gu7hbuh.1374804892449@email.android.com> <51F1ED8F.40703@zytor.com> <20130726083314.4e2e333f@jbarnes-desktop> <20130726202418.GD21415@gmail.com>
In-Reply-To: <20130726202418.GD21415@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 01:24 PM, Ingo Molnar wrote:
> 
> Am I being too pedantic in expecting that we still mark it 
> e820-reserved?
> 
> This area really isnt an ordinary PCI resource such as a 
> BAR or an MMIO region. It's truly system RAM (which cannot 
> be moved/reallocated), used by graphics hardware, and the 
> firmware should have marked it reserved.
> 
> (The end result should be the same in any case, so this is 
> a detail.)
> 

I, too, would prefer to see it marked as reserved.

	-hpa


