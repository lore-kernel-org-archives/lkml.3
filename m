Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaDKSSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:18:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35157 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaDKSSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <53479F0B.6070909@broadcom.com>
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
 <53451077.2030102@openwrt.org> <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
 <20140409191225.GA10560@kroah.com> <CAB=NE6VqY8yXoYuE0o01vq86imY8EtqLdkPa4bGMvR3bTaj5KQ@mail.gmail.com>
 <20140409202224.GA12953@kroah.com> <CAB=NE6XY5++p7hJQpQdwrFNUcGbUsKpC+oJiZQciXNduo+8j8A@mail.gmail.com>
 <20140409210613.GA14392@kroah.com> <s5heh15pr18.wl%tiwai@suse.de>
 <CAB=NE6VeNTFeGxKXpYunkU-W=JPLMpOnrehttvsqB+yXkdz5fg@mail.gmail.com>
 <5346CF27.3070406@broadcom.com> <CAB=NE6Wpa4gG14+XYVkT_=_t-cZXvO0FD_Q1T7tB1yiSmNBraw@mail.gmail.com>
 <53479F0B.6070909@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 11 Apr 2014 11:18:30 -0700
X-Google-Sender-Auth: P9eXLRoKdA8O35ubyNxpjrBLVQE
Message-ID: <CAB=NE6WPm+as8x7+MEpm9E_jWffZuOe6yzYoiLFowLMroWn=bA@mail.gmail.com>
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

On Fri, Apr 11, 2014 at 12:51 AM, Arend van Spriel <arend@broadcom.com> wrote:
> That was 2 years ago when you asked me ;-) Since then I have been using it
> to backport the brcm80211 mainline drivers to 1) Android kernel, ie. 3.4
> kernel, and 2) Fedora 19 which is actually fixed to 3.11 kernel.
>
> So we use backports these days for enabling brcm80211 drivers on various
> test equipment that uses older kernels.

Neat! All the kernels seem covered, what stuff was using the older
stuff and can those not be moved to newer kernels ?

  Luis
