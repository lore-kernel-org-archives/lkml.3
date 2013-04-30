Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100Ab3D3Sml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:42:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:39734 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3D3Smh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:42:37 -0400
Message-ID: <51801080.6050809@infradead.org>
Date: Tue, 30 Apr 2013 11:42:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa <alsa-devel@alsa-project.org>
Subject: Re: linux-next: Tree for Apr 30 (sound)
References: <20130430165730.7779d7e5d8fdca911213cce7@canb.auug.org.au>
In-Reply-To: <20130430165730.7779d7e5d8fdca911213cce7@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 23:57, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> Changes since 20130429:
> 


when CONFIG_PROC_FS is not enabled:

sound/core/memalloc.c: In function 'snd_mem_exit':
sound/core/memalloc.c:525:20: error: 'SND_MEM_PROC_FILE' undeclared (first use in this function)


-- 
~Randy
