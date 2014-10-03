Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaJCNHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:07:07 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42363 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCNHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:07:04 -0400
Message-ID: <542E9F75.6070407@6wind.com>
Date: Fri, 03 Oct 2014 15:07:01 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, akpm@linux-foundation.org, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu, Thierry Herbelot <thierry.herbelot@6wind.com>
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the directory
 entries
References: <20131003.150947.2179820478039260398.davem@davemloft.net> <1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com> <1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com> <20141002172814.GA2435@p183.telecom.by>
In-Reply-To: <20141002172814.GA2435@p183.telecom.by>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/10/2014 19:28, Alexey Dobriyan a écrit :
> On Thu, Oct 02, 2014 at 05:25:01PM +0200, Nicolas Dichtel wrote:
>> +static inline unsigned int proc_pde_name_hash(const unsigned char *name,
>> +					      const unsigned int len)
>> +{
>> +	return full_name_hash(name, len) & PROC_PDE_HASH_MASK;
>> +}
>
> PDE already stands for "proc dir entry" :^)
>
> 	Alexey
>
Oops, will fix it in v2.


Thank you,
Nicolas
