Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaKDTdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:33:19 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60938 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaKDTdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:33:18 -0500
Message-ID: <545929F9.7010301@amacapital.net>
Date: Tue, 04 Nov 2014 11:33:13 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86-64: allow using RIP-relative addressing for per-CPU
 data
References: <5458A12C0200007800044A97@mail.emea.novell.com>
In-Reply-To: <5458A12C0200007800044A97@mail.emea.novell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 12:49 AM, Jan Beulich wrote:
> Observing that per-CPU data (in the SMP case) is reachable by
> exploiting 64-bit address wraparound, these two patches
> arrange for using the one byte shorter RIP-relative addressing
> forms for the majority of per-CPU accesses.
> 
> 1: handle PC-relative relocations on per-CPU data
> 2: use RIP-relative addressing for most per-CPU accesses
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 

I'm lost here.  Can you give an example of a physical and virtual
address of an instruction, the address within the gs segment, and why
the relocations are backwards?

--Andy
