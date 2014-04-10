Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965832AbaDJS5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:57:19 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43368 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbaDJS5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:57:15 -0400
MIME-Version: 1.0
In-Reply-To: <5346CF27.3070406@broadcom.com>
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
 <53451077.2030102@openwrt.org> <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
 <20140409191225.GA10560@kroah.com> <CAB=NE6VqY8yXoYuE0o01vq86imY8EtqLdkPa4bGMvR3bTaj5KQ@mail.gmail.com>
 <20140409202224.GA12953@kroah.com> <CAB=NE6XY5++p7hJQpQdwrFNUcGbUsKpC+oJiZQciXNduo+8j8A@mail.gmail.com>
 <20140409210613.GA14392@kroah.com> <s5heh15pr18.wl%tiwai@suse.de>
 <CAB=NE6VeNTFeGxKXpYunkU-W=JPLMpOnrehttvsqB+yXkdz5fg@mail.gmail.com> <5346CF27.3070406@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 10 Apr 2014 11:56:52 -0700
X-Google-Sender-Auth: nDGeJH8BEvfqxcfyaR70O8AoA5U
Message-ID: <CAB=NE6Wpa4gG14+XYVkT_=_t-cZXvO0FD_Q1T7tB1yiSmNBraw@mail.gmail.com>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
To: Arend van Spriel <arend@broadcom.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felix Fietkau <nbd@openwrt.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 10:04 AM, Arend van Spriel <arend@broadcom.com> wrote:
> Ok, I guess my voice was cracking when I mentioned 2.6.38 as being used over
> here. I am probably alone in that desert.

I thought broadcom didn't use backports? If they do can you explain
how? Also what drivers do you need enabled for your use case ?

  Luis
