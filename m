Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaAMNbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:31:10 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36705 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaAMNbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:31:09 -0500
Message-ID: <52D3EA9B.6020404@cogentembedded.com>
Date: Mon, 13 Jan 2014 17:31:07 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Oliva <oliva@gnu.org>, Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [3.13-rc regression] Unbreak Loongson2 and r4k-generic flush
 icache range
References: <ord2jwnmwd.fsf@livre.home>
In-Reply-To: <ord2jwnmwd.fsf@livre.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-01-2014 15:26, Alexandre Oliva wrote:

> Commit 14bd8c08, that replaced Loongson2-specific ifdefs with cpu tests,

    Please also specify that commit's summary line in parens.

> inverted the CPU test in local_r4k_flush_icache_range.  Loongson2 won't
> boot up using the generic icache flush code.  Presumably other CPUs
> might face other problems when presented with Loongson2-specific icache
> flush code too.  This patch enabled my Yeeloong to boot up successfully
> a 3.13-rc kernel for the first time, after a long git bisect session.

> Signed-off-by: Alexandre Oliva <lxoliva@fsfla.org>

    Fix for this issue has been posted long ago:

http://marc.info/?l=linux-mips&m=138575576803890

WBR, Sergei

