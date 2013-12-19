Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3LSCeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:34:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62299 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3LSCes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:34:48 -0500
X-IronPort-AV: E=Sophos;i="4.95,510,1384272000"; 
   d="scan'208";a="9287331"
Message-ID: <52B24D94.6090600@cn.fujitsu.com>
Date: Thu, 19 Dec 2013 09:36:20 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Borkmann <borkmann@iogearbox.net>
CC: Fengguang Wu <fengguang.wu@intel.com>, davem@davemloft.net,
        ffusco@redhat.com, kbuild-all@01.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [net-next/master PATCH] lib: fix compile warning in hashlib_init
References: <1387415314-21786-1-git-send-email-gaowanlong@cn.fujitsu.com> <20131219011506.GA27326@localhost> <52B24C92.8050201@iogearbox.net>
In-Reply-To: <52B24C92.8050201@iogearbox.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 09:35:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 09:35:53,
	Serialize complete at 2013/12/19 09:35:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 09:32 AM, Daniel Borkmann wrote:
> On 12/19/2013 02:15 AM, Fengguang Wu wrote:
>> CC the list.
>>
>> On Thu, Dec 19, 2013 at 09:08:34AM +0800, Wanlong Gao wrote:
>>> /git/linux/lib/hash.c: In function 'hashlib_init':
>>> /git/linux/lib/hash.c:35:2: warning: passing argument 1 of 'setup_arch_fast_hash' from incompatible pointer type [enabled by default]
>>> /git/linux/include/asm-generic/hash.h:5:20: note: expected 'struct arch_hash_ops *' but argument is of type 'struct fast_hash_ops *'
>>>
>>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> That's already in netdev patchwork:
> 
> http://patchwork.ozlabs.org/patch/302908/

Nice, thank you.

Regards,
Wanlong Gao

> 
> Thanks !
> 

