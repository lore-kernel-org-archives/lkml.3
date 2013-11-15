Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3KOUiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 15:38:25 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:41458 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3KOUiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:38:17 -0500
Message-ID: <52868637.40007@gmail.com>
Date: Fri, 15 Nov 2013 21:38:15 +0100
From: Chang <changxiangzhong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
CC: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dreibh@simula.no, ernstgr@simula.no
Subject: Re: [PATCH] net: sctp: recover a tranport when an ack comes
References: <1384461624-17636-1-git-send-email-changxiangzhong@gmail.com> <5285884F.8030907@gmail.com> <20131115123055.GA29877@hmsreliant.think-freely.org> <5286291A.7060507@gmail.com> <20131115145609.GC29877@hmsreliant.think-freely.org> <52867D2E.2090907@gmail.com> <52868582.2020509@gmail.com>
In-Reply-To: <52868582.2020509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much Neil and Vlad!
That's exactly what I've been looking for. I'm quite unfamiliar iwth the 
sctp_net_init part.

Have a nice weekend!
