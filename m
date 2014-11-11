Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaKKWdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:33:33 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64844 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKKWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:33:31 -0500
MIME-Version: 1.0
In-Reply-To: <8a1a6be73725414cb3360011fa69581c@BL2PR03MB132.namprd03.prod.outlook.com>
References: <20141110113248.GA25131@sucs.org>
	<8a1a6be73725414cb3360011fa69581c@BL2PR03MB132.namprd03.prod.outlook.com>
Date: Tue, 11 Nov 2014 22:33:29 +0000
Message-ID: <CALjAwxhVKBYO3TvAzgd_Oi5Cne1yFkvX5L=pzkfX3Rgcd7nL2g@mail.gmail.com>
Subject: Re: skbuff_fclone_cache poison overwritten
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Long Li <longli@microsoft.com>
Cc: "David S. Miller" <davem@davemloft.net>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 19:27, Long Li <longli@microsoft.com> wrote:
> It's not obvious if this is a problem with hv_netvsc, or other code.
>
> Can you try to use a legacy network device and see if this issue still exists?

Good point - I'll try that tomorrow (your guess that I was currently
using non-legacy/paravirtualised network cards was right).

-- 
Sitsofe | http://sucs.org/~sits/
