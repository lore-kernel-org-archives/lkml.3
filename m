Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaIBSVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:21:36 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40985 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaIBSVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:21:34 -0400
Message-ID: <1409682093.26422.5.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: RTNL: assertion failed at net/ipv6/addrconf.c (1699)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <cwang@twopensource.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Tommi Rantala <tt.rantala@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Date: Tue, 02 Sep 2014 11:21:33 -0700
In-Reply-To: <CAHA+R7PY=Pu7VKA3wp1DxeJRckxPNWL-xfv2XXkpaY935kt61A@mail.gmail.com>
References: <CA+ydwtoDwQVg_BWrxxdpUyJ7Up60GtxTCLYe_5vFdV2td_kGhQ@mail.gmail.com>
	 <CAHA+R7MZCDGRhSf=UuVCGQvNo03wVziZQB_X30rwNf6hmHipQA@mail.gmail.com>
	 <20140829195339.GA9780@kria> <1409363489.2980.17.camel@localhost>
	 <CAHA+R7ODa+LrdwSrS7HcBfwwq8_fpj-Ld0OCDtcOqkpCdZCvxg@mail.gmail.com>
	 <1409680684.972417.162793869.03CF8A61@webmail.messagingengine.com>
	 <CAHA+R7Mwy1SCpEUgGf9BdLEro6N-3t89KU=xL0iuzgOppXELrQ@mail.gmail.com>
	 <1409681487.26422.1.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAHA+R7PY=Pu7VKA3wp1DxeJRckxPNWL-xfv2XXkpaY935kt61A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-02 at 11:15 -0700, Cong Wang wrote:

> That is what we do when backporting patches, I can do that if David asks
> me to backport it, but you know for netdev that is David's work.
> 
> (I am not saying I don't want to help him, I just want to point out the fact.
> I am very pleased to help David for stable backports as long as he asks)

Problem is : your patch submission do not identify bug origin.

You claim you want to help, but you do not provide the basic thing that
_really_ helps.

The proper way to identify bug origin is to add in the headers one
line :

Fixes: 12-digit-SHA1 ("patch title")



