Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaBTUb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:31:56 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:57739 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaBTUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:31:54 -0500
MIME-Version: 1.0
In-Reply-To: <1392857777.22693.14.camel@dcbw.local>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
 <1392433180-16052-3-git-send-email-mcgrof@do-not-panic.com>
 <1392668638.21106.5.camel@dcbw.local> <CAB=NE6XGBp1RwO63W0ac6tTr9JcRM9TB9sap4pa+8PMWwjxu6g@mail.gmail.com>
 <1392828325.21976.6.camel@dcbw.local> <CAB=NE6VpUqwNNY4pgbS6du2VsZ6dH0TzQYXmiw6GGN-EiOsV6g@mail.gmail.com>
 <1392857777.22693.14.camel@dcbw.local>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 20 Feb 2014 12:31:30 -0800
X-Google-Sender-Auth: nIToQvusOlMqLMEI9lWaYiQYOBs
Message-ID: <CAB=NE6Xvqcdje5OSxjzTRa3wv-vZHr+MJHY86ZCfFXU2Lpzi8Q@mail.gmail.com>
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
To: Dan Williams <dcbw@redhat.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 4:56 PM, Dan Williams <dcbw@redhat.com> wrote:
> Note that there isn't yet a disable_ipv4 knob though, I was
> perhaps-too-subtly trying to get you to send a patch for it, since I can
> use it too :)

Sure, can you describe a little better the use case, as I could use
that for the commit log. My only current use case was the xen-netback
case but Zoltan has noted a few cases where an IPv4 or IPv6 address
*could* be used on the backend interfaces (which I'll still poke as
its unclear to me why they have 'em).

  Luis
