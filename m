Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3LLPqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:46:40 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:50969 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3LLPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:46:38 -0500
Date: Thu, 12 Dec 2013 16:46:37 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christian Grothoff <grothoff@in.tum.de>,
        Jacob Appelbaum <jacob@appelbaum.net>,
        Andi Kleen <andi@firstfloor.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, knock@gnunet.org
Subject: Re: [PATCH] TCP: add option for silent port knocking with integrity protection
Message-ID: <20131212154637.GG4675@order.stressinduktion.org>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	Christian Grothoff <grothoff@in.tum.de>,
	Jacob Appelbaum <jacob@appelbaum.net>,
	Andi Kleen <andi@firstfloor.org>,
	Stephen Hemminger <stephen@networkplumber.org>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, knock@gnunet.org
References: <52A75EF8.3010308@in.tum.de> <20131211.150137.368953964178408437.davem@davemloft.net> <52A8C8B4.4060109@in.tum.de> <20131211122637.75b09074@nehalam.linuxnetplumber.net> <87bo0nulkt.fsf@tassilo.jf.intel.com> <52A8ECF5.3070604@in.tum.de> <20131212012317.GL21717@two.firstfloor.org> <52A98DBF.4090702@appelbaum.net> <52A9A17F.6050505@in.tum.de> <1386858864.19078.60.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386858864.19078.60.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 06:34:24AM -0800, Eric Dumazet wrote:
> With various proposals (like TCP minion), maybe its time to be able to
> implement part of TCP stack in user land (Keep the mux inside the
> kernel, and forward raw incoming packets to user land where all the
> crazy things can be done without kernel patching.)

Maybe this knocking scheme is implementable with a socket filter and we could
add a switch to tweak drop behaviour.

