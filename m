Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3J1CnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 22:43:11 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38598 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3J1CnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 22:43:10 -0400
Date: Mon, 28 Oct 2013 10:43:01 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, cl@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] percpu: little optimization on calculating
 pcpu_unit_size
Message-ID: <20131028024301.GB15642@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <1382345893-6644-3-git-send-email-weiyang@linux.vnet.ibm.com>
 <20131027123634.GL14934@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027123634.GL14934@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102802-5140-0000-0000-0000040F3A52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 08:36:34AM -0400, Tejun Heo wrote:
>On Mon, Oct 21, 2013 at 04:58:13PM +0800, Wei Yang wrote:
>> pcpu_unit_size exactly equals to ai->unit_size.
>> 
>> This patch assign this value instead of calculating from pcpu_unit_pages. Also
>> it reorder them to make it looks more friendly to audience.
>
>Ditto.  I'd rather not change unless this is clearly better.

This one change an assignement to a shift, which in my mind is a little
faster.

Well, this is just executed once during the boot time, not a big deal.

>
>Thanks.
>
>-- 
>tejun

-- 
Richard Yang
Help you, Help me

