Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaDUR6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:58:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:15846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaDUR6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,897,1389772800"; 
   d="scan'208";a="524879524"
Message-ID: <53555C24.1070100@linux.intel.com>
Date: Mon, 21 Apr 2014 10:57:56 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, WANG Chao <chaowang@redhat.com>
CC: Kees Cook <keescook@chromium.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kaslr relocation incompitable with kernel loaded high
References: <20140421105232.GB4564@dhcp-17-89.nay.redhat.com> <CAE9FiQWf+3hMZbt7Ac+vgL+8kqqQS4LKVGmWgrd5fJ4nkSgmPA@mail.gmail.com>
In-Reply-To: <CAE9FiQWf+3hMZbt7Ac+vgL+8kqqQS4LKVGmWgrd5fJ4nkSgmPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 10:56 AM, Yinghai Lu wrote:
>>
>> 32-bit relocation outside of kernel!
> 
> Interesting, when kernel get at "early console in decompress_kernel"
> kernel already in 64 bit...
> 
> what does it mean "32-bit relocation outside of kernel" ?
> 
> why 32-bit is involved ?
> 

Most addresses and immediates on 64 bits are 32 bits wide, which is why
we have the high kernel mapping in the first place.

	-hpa


