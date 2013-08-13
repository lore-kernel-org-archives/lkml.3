Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3HMQ75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:59:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60004 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3HMQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:59:56 -0400
Message-ID: <520A6607.7060002@infradead.org>
Date: Tue, 13 Aug 2013 09:59:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: linux-next: Tree for Aug 13 (xfs)
References: <20130813182832.16d18ef3dbc267c1a229bcd6@canb.auug.org.au>
In-Reply-To: <20130813182832.16d18ef3dbc267c1a229bcd6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/13 01:28, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130812:
> 

on i386:

fs/built-in.o: In function `xfs_log_calc_minimum_size':
(.text+0x1797a9): undefined reference to `__udivdi3'


-- 
~Randy
