Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab3E1GIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:08:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47504 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932969Ab3E1GIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:08:53 -0400
Message-ID: <1369721333.22004.24.camel@joe-AO722>
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, atomlin@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pshelar@nicira.com,
        mst@redhat.com, alexander.h.duyck@intel.com, aquini@redhat.com,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org
Date: Mon, 27 May 2013 23:08:53 -0700
In-Reply-To: <1369721054.3301.531.camel@edumazet-glaptop>
References: <1369599557-22677-1-git-send-email-atomlin@redhat.com>
	 <51A39A3F.8080903@redhat.com> <1369693520.3301.477.camel@edumazet-glaptop>
	 <1369715506.2034.30.camel@joe-AO722>
	 <1369721054.3301.531.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 23:04 -0700, Eric Dumazet wrote:
> If dump_stack are scary, they are scary for every k[mz]alloc() users,
> not only __alloc_skb_alloc()

True, but perhaps they are relatively rarer though
for non net use cases.


