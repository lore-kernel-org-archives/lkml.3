Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3J1Cho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 22:37:44 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39737 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3J1Chm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 22:37:42 -0400
Date: Mon, 28 Oct 2013 10:37:35 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, cl@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] percpu: merge two loops when setting up group info
Message-ID: <20131028023734.GA15642@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <1382345893-6644-2-git-send-email-weiyang@linux.vnet.ibm.com>
 <20131027123542.GK14934@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027123542.GK14934@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102802-5816-0000-0000-00000A9AB123
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 08:35:42AM -0400, Tejun Heo wrote:
>On Mon, Oct 21, 2013 at 04:58:12PM +0800, Wei Yang wrote:
>> There are two loops setting up the group info of pcpu_alloc_info. They share
>> the same logic, so merge them could be time efficient when there are many
>> groups.
>> 
>> This patch merge these two loops into one.
>
>It *looks* correct to me but I'd rather not change this unless you can
>show me this actually matters, which I find extremely doubtful given
>nr_groups would be in the order of few thousands even on an extremely
>large machine.

Tejun, thanks for your review and comments.

I agree with you that the nr_groups won't be very large, which means it will
not bring many benefits.

This is just a small code refine. If you don't like it, just drop it :-)

>
>Thanks.
>
>-- 
>tejun

-- 
Richard Yang
Help you, Help me

