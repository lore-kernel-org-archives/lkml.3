Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3JUPwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:52:55 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:48579 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3JUPwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:52:53 -0400
Date: Mon, 21 Oct 2013 17:52:52 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] 3.12.0-rcX IPv6 panic
Message-ID: <20131021155252.GA24158@order.stressinduktion.org>
Mail-Followup-To: Bob Tracy <rct@gherkin.frus.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20131021131846.GA5769@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131021131846.GA5769@gherkin.frus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Oct 21, 2013 at 08:18:46AM -0500, Bob Tracy wrote:
> Actually, a regression: the 3.11 kernel is rock-solid stable on my
> Alpha.
> 
> Beginning with 3.12.0-rc1, I can reliably trigger a kernel panic by
> executing the gogo6.net "gw6c" IPv6 client program.  If the networking
> layer is active, an "Oops" will eventually (within a day) occur regardless
> of whether I attempt to run "gw6c".  3.12.0-rcX is stable as long as I
> leave networking completely disabled.  The error has persisted up through
> -rc6.  Apologies for not mentioning this earlier, but the state of my
> PWS-433au has been questionable, and I wanted to make sure I had a
> legitimate bug sighting.
> 
> I'll have to transcribe the panic backtrace by hand: nothing makes it
> into any of the system logs :-(.  I *can* recall that every backtrace
> I've seen thus far has included one of the skb_copy() variants near the
> top of the list (first or second function).

Try to capture the panic via serial console. Otherwise a picture
would give us a first hint. Please watch out for lines like
skb_(over|under)_panic.

gw6c is a tunnel client? Can you post ip -6 tunnel ls?

(Also please send networking bugs to netdev@).

Greetings,

  Hannes

