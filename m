Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3BDPQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:16:00 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33074 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab3BDPP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:15:59 -0500
Message-ID: <510FD073.1060307@linux.vnet.ibm.com>
Date: Mon, 04 Feb 2013 09:14:59 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Mason <ric.masonn@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>, dan.magenheimer@oracle.com,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, ngupta@vflare.org, rcj@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] Make frontswap+cleancache and its friend be modularized.
References: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com> <1359881520.1328.14.camel@kernel.cn.ibm.com>
In-Reply-To: <1359881520.1328.14.camel@kernel.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020415-7606-0000-0000-00000805A204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 02:52 AM, Ric Mason wrote:
> Hi Konrad,
> On Fri, 2013-02-01 at 15:22 -0500, Konrad Rzeszutek Wilk wrote:
> 
> I have already enable frontswap,cleancache,zcache,
>  FRONTSWAP [=y]  
>  CLEANCACHE [=y]
>  ZCACHE [=y]
> But all of knode under /sys/kernel/debug/frontswap and cleancache still
> zero, my swap device is enable, where I miss?

Did you pass "zcache" in the kernel boot parameters?

Seth

