Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaIEJ4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:56:35 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:44381 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbaIEJ4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:56:33 -0400
Message-ID: <1409910985.1940.6.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2] device coredump: add new device coredump class
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonas Gorski <jogo@openwrt.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 05 Sep 2014 11:56:25 +0200
In-Reply-To: <CAOiHx=nGHGEHSLABnR9NL9ZEXYJN_TvJnyGud8mxseL2089fwg@mail.gmail.com>
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
	 <CAOiHx=nGHGEHSLABnR9NL9ZEXYJN_TvJnyGud8mxseL2089fwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 11:40 +0200, Jonas Gorski wrote:
> On Fri, Sep 5, 2014 at 10:50 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> 
> Can't you just send from the correct address? ;p

Not easily :)

> How about the following to avoid negative options:
> 
> config DEV_COREDUMP
>        bool "Enable device coredump" if EXPERT
>        default y if WANT_DEV_COREDUMP
>        help
>          Enable the device coredump mechanism for drivers wanting to
>          use it. Disabling allows for more sensitive systems or systems that
>          don't want to ever access the information to not have the code,
>          nor keep any data.
> 
>          If unsure, say Y.

Yeah, that seems reasonable. I guess I did the negative option because I
was thinking about the negative case ("I really don't want this!!!
111!!") :)

johannes

