Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3CSMN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:13:58 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39812 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3CSMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:13:56 -0400
Message-ID: <1363695234.21184.36.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 2/2] net: reset transport header if it was not
 set before transmission
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>, Daniel Borkmann <dborkman@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, edumazet@google.com
Date: Tue, 19 Mar 2013 05:13:54 -0700
In-Reply-To: <51482F55.8020900@redhat.com>
References: <1363333305-54398-1-git-send-email-jasowang@redhat.com>
	 <1363333305-54398-2-git-send-email-jasowang@redhat.com>
	 <1363399851.29475.52.camel@edumazet-glaptop>
	 <20130317.121318.1869489921021513474.davem@davemloft.net>
	 <51482F55.8020900@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 17:26 +0800, Jason Wang wrote:
> On 03/18/2013 12:13 AM, David Miller wrote:
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Fri, 15 Mar 2013 19:10:51 -0700
> >
> >> Any way we can avoid adding this to fast path, for people not using
> >> macvtap and ixgbe ?
> > Likewise I'd rather see macvtap be responsible for fixing this up by
> > setting the transport header properly, and therfore sending well
> > formed packets to the rest of the stack.
> 
> Ok, haven't checked all other possibility but looks like packet needs to
> be fixed also.

Daniel, could you post your patches if ready ?

Jason, I believe you could reuse existing flow dissector once Daniel
patches are in.



