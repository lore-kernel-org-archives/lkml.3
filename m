Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaCKGm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:42:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbaCKGm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:42:27 -0400
Date: Tue, 11 Mar 2014 08:41:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, jbenc@redhat.com,
        David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Simon Horman <horms@verge.net.au>,
        Paul Durrant <Paul.Durrant@citrix.com>, Thomas Graf <tgraf@suug.ch>,
        Miklos Szeredi <mszeredi@suse.cz>,
        =?us-ascii?B?PT9VVEYtOD9xP1BldGVyPTIwUGFuPTI4PUU2PUJEPTk4PUU1PThEPUFC?=
	 =?us-ascii?B?PUU1PUI5PUIzPTI5Pz0=?= <panweiping3@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] skbuff: skb_segment: orphan frags before copying
Message-ID: <20140311064150.GA10874@redhat.com>
References: <1394468807-25980-1-git-send-email-mst@redhat.com>
 <1394468807-25980-6-git-send-email-mst@redhat.com>
 <20140310213404.GB15352@gondor.apana.org.au>
 <20140310215236.GA7052@redhat.com>
 <20140310215640.GA15684@gondor.apana.org.au>
 <20140310220717.GA7150@redhat.com>
 <20140310221223.GA15839@gondor.apana.org.au>
 <20140310223001.GA7218@redhat.com>
 <20140311003940.GA16886@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311003940.GA16886@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 08:39:41AM +0800, Herbert Xu wrote:
> On Tue, Mar 11, 2014 at 12:30:01AM +0200, Michael S. Tsirkin wrote:
> >
> > How about we do the simple thing as the first step and try to optimize
> > as a separate patch on top?
> 
> Sure let's do that.
> 
> Cheers,

Could you send an ack to my patchset then?
Or do you have something else in mind?

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
