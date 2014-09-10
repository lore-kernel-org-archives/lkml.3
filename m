Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaIJQul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:50:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaIJQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:50:40 -0400
Message-ID: <5410815E.4080608@infradead.org>
Date: Wed, 10 Sep 2014 09:50:38 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Sep 10 (bpf)
References: <20140910185920.336180d4@canb.auug.org.au>
In-Reply-To: <20140910185920.336180d4@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 01:59, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140909:
> 

When CONFIG_MODULES is not enabled:  (seen on i386 and x86_64)

kernel/built-in.o: In function `bpf_jit_binary_alloc':
(.text+0x7689d): undefined reference to `module_alloc'
kernel/built-in.o: In function `bpf_jit_binary_free':
(.text+0x768f0): undefined reference to `module_free'


-- 
~Randy
