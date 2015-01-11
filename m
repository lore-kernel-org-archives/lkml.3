Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbbAKWrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:47:20 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbbAKWrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:47:18 -0500
Message-ID: <54B2FD73.7070208@nod.at>
Date: Sun, 11 Jan 2015 23:47:15 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: davem@davemloft.net, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        john.fastabend@gmail.com, herbert@gondor.apana.org.au,
        vyasevic@redhat.com, jiri@resnulli.us, vfalico@gmail.com,
        therbert@google.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru, kadlec@blackhole.kfki.hu,
        kaber@trash.net, pablo@netfilter.org, kay@vrfy.org
Subject: Re: [RFC] Make predictable/persistent network interface names more
 handy
References: <1421009571-5279-1-git-send-email-richard@nod.at> <20150111144236.1b693c93@urahara>
In-Reply-To: <20150111144236.1b693c93@urahara>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.01.2015 um 23:42 schrieb Stephen Hemminger:
> On Sun, 11 Jan 2015 21:52:48 +0100
> Richard Weinberger <richard@nod.at> wrote:
> 
>> Since the Linux distribution of my choice makes use of
>> predictable network interface names[0] my USB gadgets
>> are no longer usb0 but enp0s29u1u2. Same for all other network devices.
>> While I can fully understand that this new naming scheme makes sense
>> for a lot of people and makes their work easier it does not really work for me.
>> My brain is not able to remember that my Beaglebone's USB-Ethernet
>> is now enp0s29u1u2. Even after looking at the output of ifconfig
>> I have to copy&paste the interface name.
>> Instead of just disabling the feature I thought about
>> a generic solution which satisfies both needs.
> 
> Fix your distro. Easier said than done.

Sorry for using a mainstream distro. :-)

> Current systemd names are much shorter

Hmm, are you sure? When was this changed?
Maybe I misread http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-net_id.c

Thanks,
//richard
