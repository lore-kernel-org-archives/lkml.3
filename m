Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3LSBv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:51:58 -0500
Received: from www62.your-server.de ([213.133.104.62]:52150 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3LSBv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:51:57 -0500
X-Greylist: delayed 1182 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 20:51:57 EST
Message-ID: <52B24C92.8050201@iogearbox.net>
Date: Thu, 19 Dec 2013 02:32:02 +0100
From: Daniel Borkmann <borkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Wanlong Gao <gaowanlong@cn.fujitsu.com>, davem@davemloft.net,
        ffusco@redhat.com, kbuild-all@01.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [net-next/master PATCH] lib: fix compile warning in hashlib_init
References: <1387415314-21786-1-git-send-email-gaowanlong@cn.fujitsu.com> <20131219011506.GA27326@localhost>
In-Reply-To: <20131219011506.GA27326@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: borkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 02:15 AM, Fengguang Wu wrote:
> CC the list.
>
> On Thu, Dec 19, 2013 at 09:08:34AM +0800, Wanlong Gao wrote:
>> /git/linux/lib/hash.c: In function 'hashlib_init':
>> /git/linux/lib/hash.c:35:2: warning: passing argument 1 of 'setup_arch_fast_hash' from incompatible pointer type [enabled by default]
>> /git/linux/include/asm-generic/hash.h:5:20: note: expected 'struct arch_hash_ops *' but argument is of type 'struct fast_hash_ops *'
>>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

That's already in netdev patchwork:

http://patchwork.ozlabs.org/patch/302908/

Thanks !
