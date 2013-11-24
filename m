Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab3KXBtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 20:49:13 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35817 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3KXBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 20:49:12 -0500
Date: Sun, 24 Nov 2013 09:48:58 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, cl@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] percpu: stop the loop when a cpu belongs to a new
 group
Message-ID: <20131124014858.GA10185@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20131027123008.GJ14934@mtj.dyndns.org>
 <20131028030055.GC15642@weiyang.vnet.ibm.com>
 <20131028113120.GB11541@mtj.dyndns.org>
 <20131028151746.GA7548@weiyang.vnet.ibm.com>
 <20131120030056.GA15273@weiyang.vnet.ibm.com>
 <20131120055121.GA13754@mtj.dyndns.org>
 <20131122230400.GG8981@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122230400.GG8981@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112401-5564-0000-0000-00000ACEC427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 06:04:00PM -0500, Tejun Heo wrote:
>Hello,
>
>On Wed, Nov 20, 2013 at 12:51:21AM -0500, Tejun Heo wrote:
>> The patch is just extremely marginal.  Ah well... why not?  I'll apply
>> it once -rc1 drops.
>
>So, I was about to apply this patch but decided against it.  It
>doesn't really make anything better and the code looks worse
>afterwards.

Ok, that's fine. Maybe we could find a better way :-)

>
>Thanks.
>
>-- 
>tejun

-- 
Richard Yang
Help you, Help me

