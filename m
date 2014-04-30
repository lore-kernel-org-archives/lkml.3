Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828AbaD3RZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:25:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbaD3RZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:25:50 -0400
Message-ID: <536131F4.3040509@zytor.com>
Date: Wed, 30 Apr 2014 10:25:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lutomriski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] x86-64, espfix: Don't leak bits 31:16 of %esp returning
 to 16-bit stack
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com> <20140430103822.GD23736@pd.tnic> <536125F3.9050807@zytor.com> <20140430171640.GB17723@pd.tnic>
In-Reply-To: <20140430171640.GB17723@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 10:16 AM, Borislav Petkov wrote:
> On Wed, Apr 30, 2014 at 09:33:55AM -0700, H. Peter Anvin wrote:
>> Heh. I think I might have used the wrong one, though... GPLv2+ vs
>> GPLv2.
> 
> Why is GPLv2+ wrong?
> 
> I thought as long as v2 is explicitly mentioned we're fine.
> 

Fine from a Linux kernel perspective, but it is a matter of which rights
the licensor (here, Intel) wants to grant.

	-hpa

