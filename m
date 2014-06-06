Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaFFFpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:45:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38623 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaFFFpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:45:30 -0400
Message-ID: <53915571.7050801@oracle.com>
Date: Fri, 06 Jun 2014 01:45:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: net: netlink executing RO memory
References: <5390D152.30702@oracle.com>
In-Reply-To: <5390D152.30702@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 04:21 PM, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [  306.065161] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> [  306.067295] BUG: unable to handle kernel paging request at ffff880053b8fd08

Same issue reproduced multiple times with exactly the same trace, so I think that it
rules out random memory corruption.


Thanks,
Sasha
