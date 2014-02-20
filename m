Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaBTBBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:01:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaBTBBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:01:41 -0500
Message-ID: <1392858138.22693.21.camel@dcbw.local>
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
From: Dan Williams <dcbw@redhat.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Zoltan Kiss <zoltan.kiss@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Wed, 19 Feb 2014 19:02:18 -0600
In-Reply-To: <20140220005833.GF1179@order.stressinduktion.org>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
	 <1392433180-16052-3-git-send-email-mcgrof@do-not-panic.com>
	 <1392668638.21106.5.camel@dcbw.local>
	 <CAB=NE6XGBp1RwO63W0ac6tTr9JcRM9TB9sap4pa+8PMWwjxu6g@mail.gmail.com>
	 <1392828325.21976.6.camel@dcbw.local>
	 <CAB=NE6VpUqwNNY4pgbS6du2VsZ6dH0TzQYXmiw6GGN-EiOsV6g@mail.gmail.com>
	 <1392857777.22693.14.camel@dcbw.local>
	 <20140220005833.GF1179@order.stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 01:58 +0100, Hannes Frederic Sowa wrote:
> On Wed, Feb 19, 2014 at 06:56:17PM -0600, Dan Williams wrote:
> > Note that there isn't yet a disable_ipv4 knob though, I was
> > perhaps-too-subtly trying to get you to send a patch for it, since I can
> > use it too :)
> 
> Do you plan to implement
> <http://datatracker.ietf.org/doc/draft-ietf-sunset4-noipv4/>?
> 
> ;)

Well, not specifically, but with NetworkManager we do have a "disable
IPv4" method for IPv4, which now just doesn't do any kind of IPv4, but
obviously doesn't disable IPv4 entirely because that's not possible.  I
was only thinking that it would be nice to actually guarantee that IPv4
was disabled, just like disable_ipv6 does.

But we could certainly implement that draft if a patch shows up or if it
bubbled up the priority stack :)

Dan

