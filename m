Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbaGATiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:38:14 -0400
Received: from puma-aaisp.mxtelecom.com ([81.187.36.3]:39159 "EHLO
	puma.mxtelecom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756400AbaGATiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:38:11 -0400
Date: Tue, 1 Jul 2014 20:38:07 +0100 (BST)
From: Edward Allcutt <edward.allcutt@openmarket.com>
To: David Miller <davem@davemloft.net>
cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Edward Allcutt <edward.allcutt@openmarket.com>
Subject: Re: [PATCH] ipv4: icmp: Fix pMTU handling for rare case
In-Reply-To: <20140701.120730.2210532934459689553.davem@davemloft.net>
Message-ID: <alpine.DEB.2.10.1407012020011.5997@tabini.allcutt.me.uk>
References: <alpine.DEB.2.10.1407010937120.5997@tabini.allcutt.me.uk> <20140701.110510.2218293817137911715.davem@davemloft.net> <alpine.DEB.2.10.1407011912440.5997@tabini.allcutt.me.uk> <20140701.120730.2210532934459689553.davem@davemloft.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, David Miller wrote:
> I didn't say I won't apply the patch, actually the email you are
> replying to is strictly about figuring out what's happening on
> the OpenBSD systems for their sake.

Ah, sorry for the misunderstanding.

I'll see if I can find the place in the BSD code. Although I think in 
principle this could come up in other "technically correct" router 
implementations.

-- 
Edward Allcutt
