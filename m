Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaHNGb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:31:26 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:17123 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaHNGbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:31:25 -0400
Message-ID: <53EC57B9.8080903@c-s.fr>
Date: Thu, 14 Aug 2014 08:31:21 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Issue with commit 33c133cc7598e60976a phy: IRQ cannot be shared
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Segei, Florian and David,

I have an hardware with two ethernet interfaces, and with the two PHYs 
inside the same component INTEL LXT973 which has only one interrupt.
I also have another hardware with two ethernet interfaces and two 
independant PHYs. But the two PHYs are wired to the same interrupt.
This is working perfectly up to Linux 3.12.

But since your commit, introduced in Linux 3.13, my interfaces don't 
work anymore as the second PHYs can't register IRQ.

Reading the commit log, I can't really understand the reason for the change.
Is it really worth it, and therefore how shall my case be handled ?

Christophe

