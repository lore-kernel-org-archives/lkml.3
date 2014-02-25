Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaBYQW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:22:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaBYQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:22:24 -0500
Message-ID: <530CC33F.8050805@infradead.org>
Date: Tue, 25 Feb 2014 08:22:23 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 25 (externally_visible attribute)
References: <20140225184832.420d9e32378e9f68a9432bcb@canb.auug.org.au>
In-Reply-To: <20140225184832.420d9e32378e9f68a9432bcb@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 11:48 PM, Stephen Rothwell wrote:
> Hi all,
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140224:
> 

I'm seeing several of these warnings (since 20140224):

arch/x86/crypto/sha1_ssse3_glue.c:43:1: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]
arch/x86/crypto/sha256_ssse3_glue.c:56:1: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]
arch/x86/crypto/sha512_ssse3_glue.c:55:1: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]
arch/x86/kernel/machine_kexec_32.c:191:12: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]


-- 
~Randy
