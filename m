Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaDPDye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:54:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37652 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaDPDyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:54:32 -0400
Message-ID: <534DFEDC.8090503@zytor.com>
Date: Tue, 15 Apr 2014 20:54:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com>
In-Reply-To: <534DFD61.4070700@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 08:47 PM, Sasha Levin wrote:
> 
> Yes, if kmemcheck for some reason needs to figure out if an instruction
> is a MOV variant we'll need to list quite a few mnemonics, but that list
> will be much shorter and more readable than a corresponding list of opcodes.
> 

You're completely missing my point.  If you are looking at MOV, with
80%+ probability you're doing something very, very wrong, because you
will be including instructions that do something completely different
from what you thought.

This is true for a lot of the x86 instructions.

	-hpa


