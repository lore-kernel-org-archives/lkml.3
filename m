Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaCDBoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:44:23 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41318 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbaCDBoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:44:21 -0500
Date: Mon, 3 Mar 2014 17:44:16 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [RFC v3 0/6] networking: address root block upon initialization
Message-ID: <20140303174416.2240ec9f@nehalam.linuxnetplumber.net>
In-Reply-To: <CAB=NE6XLe0jkMTP=SkFDhMaWiubHTj7zyJwbbOcoCkkhYpBpdA@mail.gmail.com>
References: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
	<CAB=NE6XLe0jkMTP=SkFDhMaWiubHTj7zyJwbbOcoCkkhYpBpdA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014 17:05:18 -0800
"Luis R. Rodriguez" <mcgrof@suse.com> wrote:

> On Mon, Mar 3, 2014 at 2:46 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> <-- snip -->
> 
> > As I tested using the root block preference I noticed that if a net_device
> > slave under the bridge gets the designated root port prior to setting in
> > userspace the root_block feature enabling the feature won't kick the
> > bridge to remove that net_device from the designated port. I addressed
> > that issue and also upkeeping the initial random MAC address given to
> > the bridge as if othwerwise we'd end up with a zero MAC address bridge
> > if we root block all ports. I have only done local tests I'd appreciate a
> > bit more wide test coverage and review.
> 
> 
> Stephen,
> 
> I should note that even if we discard patches 4-6 patches for an
> alternative implementation patches 1-3 should still be applicable for
> review. Let me know what you think of those.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I agree with 0-3 as normal improvements.
