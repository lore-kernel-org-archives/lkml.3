Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaGJLpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:45:39 -0400
Received: from canardo.mork.no ([148.122.252.1]:57425 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaGJLpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:45:38 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        dingtianhong <dingtianhong@huawei.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v7 10/33] net: dummy - set name assign type
Organization: m
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	<1404980258-30853-11-git-send-email-teg@jklm.no>
	<87pphdh85q.fsf@nemi.mork.no>
	<CAG-2HqWSRRfW1EygXd_1=eYFsTeDd3SsJBfF3BuH35hgGxogxA@mail.gmail.com>
Date: Thu, 10 Jul 2014 13:44:54 +0200
In-Reply-To: <CAG-2HqWSRRfW1EygXd_1=eYFsTeDd3SsJBfF3BuH35hgGxogxA@mail.gmail.com>
	(Tom Gundersen's message of "Thu, 10 Jul 2014 12:12:28 +0200")
Message-ID: <87d2ddh1zd.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Gundersen <teg@jklm.no> writes:

> The result of
>
> modprobe dummy numdummies=2
>
> is to create dummy0 and dummy1, always with the same names.
>
> The result of
>
> ip link add type dummy
>
> is to create dummyX, where X depends on what came before.

Which is no different. That's exacly what happens when
"modprobe dummy numdummies=2" creates the two first interfaces.


 ip link add link wwan0 name dummy0 type vlan id 2
 modprobe dummy numdummies=2

ends up with dummy1 and dummy2 created by the dummy driver.

You are trying to make up differences that just aren't there.



Bjørn
