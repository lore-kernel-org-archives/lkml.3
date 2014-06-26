Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbaFZAlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:41:51 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:49166 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaFZAlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <1403728972-29548-4-git-send-email-zoltan.kiss@citrix.com>
References: <1403728972-29548-1-git-send-email-zoltan.kiss@citrix.com>
	<1403728972-29548-4-git-send-email-zoltan.kiss@citrix.com>
Date: Wed, 25 Jun 2014 17:41:47 -0700
Message-ID: <CAHA+R7NR4PmLbwmKXL8iwdwm3STNmpT4iZCp3VgB2zAqWZm7XQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3 RFC] pktgen: Allow sending TCP packets
From: Cong Wang <cwang@twopensource.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Mathias Krause <minipli@googlemail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>,
        Joe Perches <joe@perches.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 1:42 PM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> This is a prototype patch to enable sending TCP packets with pktgen. The
> original motivation is to test TCP GSO with xen-netback/netfront, but I'm not
> sure about how the checksum should be set up, and also someone should verify the
> GSO settings I'm using.
>

What's the point of sending TCP packets since you don't establish a TCP
connection?
