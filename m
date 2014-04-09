Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbaDIS3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:29:20 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35176 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaDIS3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <53451077.2030102@openwrt.org>
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
 <53451077.2030102@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 9 Apr 2014 11:28:55 -0700
X-Google-Sender-Auth: fE6bRtJu3OOibBgZV8rzJQtDQ2Q
Message-ID: <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
To: Felix Fietkau <nbd@openwrt.org>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 2:18 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> The oldest kernel in OpenWrt that we're still supporting with updates of
> the backports tree is 3.3, so raising the minimum requirement to 3.0 is
> completely fine with me.

OK note that 3.3 is not listed on kernel.org as supported. I'm fine in
carrying the stuff for those for now but ultimately it'd also be nice
if we didn't even have to test the kernels in between which are not
listed. This does however raise the question of how often a kernel in
between a list of supported kernels gets picked up to be supported
eventually. Greg, Jiri, do you happen to know what the likelyhood of
that can be?

> I'm looking forward to getting rid of patches for older kernels that
> often get in the way when using various wireless-testing versions ;)

:D

  Luis
