Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaH3KuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:50:23 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:9584 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaH3KuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:50:21 -0400
Date: Sat, 30 Aug 2014 12:50:02 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Cong Wang <cwang@twopensource.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        trinity@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: RTNL: assertion failed at net/ipv6/addrconf.c (1699)
Message-ID: <20140830105002.GA18155@kria>
References: <CA+ydwtoDwQVg_BWrxxdpUyJ7Up60GtxTCLYe_5vFdV2td_kGhQ@mail.gmail.com>
 <CAHA+R7MZCDGRhSf=UuVCGQvNo03wVziZQB_X30rwNf6hmHipQA@mail.gmail.com>
 <20140829195339.GA9780@kria>
 <CAHA+R7PLR7QHZuPriCErpuYL2_T+EiMhKF=qEKXjdgubno_StA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHA+R7PLR7QHZuPriCErpuYL2_T+EiMhKF=qEKXjdgubno_StA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-29, 15:54:48 -0700, Cong Wang wrote:
> [...]
> 
> You are absolutely right here.
> 
> Can I have your Signed-off-by and Tested-by before sending the patch
> formally?
> 
> Thanks!

Sure:

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Tested-by: Sabrina Dubroca <sd@queasysnail.net>


Thanks,

-- 
Sabrina
