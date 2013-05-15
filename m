Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab3EORJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:09:54 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:47178 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759551Ab3EORJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:09:52 -0400
Date: Wed, 15 May 2013 18:09:47 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Holger Hoffstaette <holger.hoffstaette@googlemail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: r8169 on 3.8.13, 3.9.2, 3.10-rc1, was Re: [ 00/73] 3.8.13-stable
 review
Message-ID: <20130515170947.GA10174@milliways>
References: <20130509222757.917088509@linuxfoundation.org>
 <pan.2013.05.10.10.54.26.943195@googlemail.com>
 <20130515000715.GA20099@milliways>
 <20130515061401.GA4382@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130515061401.GA4382@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=wom5GMh1gUkA:10 a=GZrByrPwTHwA:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=NLZqzBF-AAAA:8 a=lOyOCk0l6PpxnmqrSJQA:9 a=wPNLvfGTeEIA:10 a=_dQi-Dcv4p4A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 08:14:01AM +0200, Francois Romieu wrote:
> Ken Moffat <zarniwhoop@ntlworld.com> :
> [...]
> >  Cc'ing to netdev because I don't think this has had a response, and
> 
> A patch has been sent to netdev a few hours ago. It needs more work,
> especially testing (hint, hint) as I don't have a proven test case yet.
> 
> Please note:
> - if you don't use a 8168evl (check your dmesg for the XID line emitted
>   by the r8169 driver), you are not the experiencing the same bug.
[    3.174180] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at
0xffffc90000008000, c8:60:00:97:07:35, XID 0c900800 IRQ 41

> - if you don't enable Tx checksum offload (distro/vendor dependent though
>   disabled by default in the vanilla driver, see ethtool -k eth0,
>   ethtool -K eth0 tx on sg on)), you are not the experiencing the same
>   bug.

 If it is disabled by default then my problem is different (I don't
have an ethtool program)

> - if you are experiencing the same bug, 3.10-rc1 should work again
>   after reverting e5195c1f31f399289347e043d6abf3ffa80f0005
> 
> If someone comes with a failing network capture and a working one, it will
> save time. A 64 bytes (max) packet is not correctly transmitted.
> 
> -- 
> Ueimor

 Thanks for the detailed comments, looks as if my intermittent
problem is something else.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
