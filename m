Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab3KZXOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:14:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43184 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3KZXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:14:04 -0500
Message-ID: <52952B2B.20309@oracle.com>
Date: Tue, 26 Nov 2013 18:13:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: kaber@trash.net, kadlec@blackhole.kfki.hu,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: netfilter: active obj WARN when cleaning up
References: <522B25B5.6000808@oracle.com> <5294F27D.4000108@oracle.com> <20131126230709.GA10948@localhost>
In-Reply-To: <20131126230709.GA10948@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 06:07 PM, Pablo Neira Ayuso wrote:
> On Tue, Nov 26, 2013 at 02:11:57PM -0500, Sasha Levin wrote:
>> >Ping? I still see this warning.
> Did your test include patch 0c3c6c00c6?

Yeah, it reproduces with today's -next tree, which includes that commit.


Thanks,
Sasha

