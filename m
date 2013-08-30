Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3H3TOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:14:24 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:52307 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3H3TOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130830191146.GA12090@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
	<20130830184611.GA27455@spo001.leaseweb.com>
	<20130830191146.GA12090@roeck-us.net>
Date: Fri, 30 Aug 2013 12:14:20 -0700
X-Google-Sender-Auth: esyzUZEYAEC6bpjqheTorSnGze4
Message-ID: <CA+55aFyxHsKhtqqz9jTDYo89bCNqCWhjHGJ4HzFrHnJ0yxLXjQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] Drop support for Renesys H8/300 architecture
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:11 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> I would not mind if Linus would agree to pull it right away for 3.12,
> but that seems to be a bit on the fast side.

I'm ok with code deletion patches, I don't think that would be a
problem. I didn't check them, but I assume this is all literally just
removing code that is conditional on h8/300 config options?

              Linus
