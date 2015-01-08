Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbbAHOnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:43:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:43452 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbbAHOnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:43:15 -0500
X-IronPort-AV: E=Sophos;i="5.07,723,1413244800"; 
   d="scan'208";a="213349441"
Message-ID: <54AE9781.5050501@citrix.com>
Date: Thu, 8 Jan 2015 14:43:13 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@linux.intel.com>, Juergen Gross <jgross@suse.com>
CC: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [xen] 054954eb051f: -49.7% kernel-size.bss
References: <1420685923.6201.91.camel@linux.intel.com>
In-Reply-To: <1420685923.6201.91.camel@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/15 02:58, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> commit 054954eb051f35e74b75a566a96fe756015352c8 ("xen: switch to linear virtual mapped sparse p2m list")
> 
> testbox/testcase/testparams: vm-kbuild-yocto-ia32/boot/1
> 
> 0aad5689837c882d  054954eb051f35e74b75a566a9  
> ----------------  --------------------------  
>          %stddev     %change         %stddev
>              \          |                \  
>    4161536 ±  0%     -49.7%    2093056 ±  0%  kernel-size.bss

This is a good thing, right?

>                                     kernel-size.bss
> 
>   4.5e+06 *+-*--*--*-*--*--*--*--*--*--*--*-*--*--*--*----------------------+
>           |                                             *..*..              |
>           |                                                   *..*.*..*..*..*
>     4e+06 ++                                                                |
>           |                                                                 |
>           |                                                                 |
>   3.5e+06 ++                                                                |
>           |                                                                 |
>     3e+06 ++                                                                |
>           |                                                                 |
>           |                                                                 |
>   2.5e+06 ++                                                                |
>           |                                                                 |
>           O  O  O  O O  O  O  O  O  O  O  O O  O  O  O  O  O  O  O O        |
>     2e+06 ++----------------------------------------------------------------+

I have no idea what this graph is supposed to be showing.

David
