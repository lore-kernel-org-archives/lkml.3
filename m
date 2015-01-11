Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbbAKWmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:42:53 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40331 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbAKWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:42:50 -0500
Date: Sun, 11 Jan 2015 14:42:36 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Richard Weinberger <richard@nod.at>
Cc: davem@davemloft.net, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        john.fastabend@gmail.com, herbert@gondor.apana.org.au,
        vyasevic@redhat.com, jiri@resnulli.us, vfalico@gmail.com,
        therbert@google.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru, kadlec@blackhole.kfki.hu,
        kaber@trash.net, pablo@netfilter.org, kay@vrfy.org
Subject: Re: [RFC] Make predictable/persistent network interface names more
 handy
Message-ID: <20150111144236.1b693c93@urahara>
In-Reply-To: <1421009571-5279-1-git-send-email-richard@nod.at>
References: <1421009571-5279-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2015 21:52:48 +0100
Richard Weinberger <richard@nod.at> wrote:

> Since the Linux distribution of my choice makes use of
> predictable network interface names[0] my USB gadgets
> are no longer usb0 but enp0s29u1u2. Same for all other network devices.
> While I can fully understand that this new naming scheme makes sense
> for a lot of people and makes their work easier it does not really work for me.
> My brain is not able to remember that my Beaglebone's USB-Ethernet
> is now enp0s29u1u2. Even after looking at the output of ifconfig
> I have to copy&paste the interface name.
> Instead of just disabling the feature I thought about
> a generic solution which satisfies both needs.

Fix your distro. Easier said than done.
Current systemd names are much shorter

P.s:  ifconfig is deprecated.

