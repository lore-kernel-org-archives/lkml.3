Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3LMMh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:37:26 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44381 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3LMMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:37:24 -0500
Message-ID: <52AAFF89.5080509@gmail.com>
Date: Fri, 13 Dec 2013 07:37:29 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Heidelberger <david.heidelberger@ixit.cz>,
        John <da_audiophile@yahoo.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com> <864985fbeb1d8148439e25ec01f47a67@ixit.cz>
In-Reply-To: <864985fbeb1d8148439e25ec01f47a67@ixit.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-09 22:51, David Heidelberger wrote:
> Hello,
> 
> this patch is used in Gentoo geek-sources and mptcp-sources (and
> probably in lot other kernel sources sets). So, there was lot testing.
> 
> It's not _big_ performance difference, but -mtune=native is nice to have.
> It could be great, if this kernel option could be fully utilized without
> need of additional patching.

This really depends on how you define 'big'.  Even a 1% performance
increase is significant for a realtime system, and for someone with a
cluster of systems, getting even a small improvement in performance on
all of the systems could mean a huge increase in effective processing power.
