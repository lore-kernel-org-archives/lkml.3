Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab3EXBTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 21:19:04 -0400
Received: from intranet.asianux.com ([58.214.24.6]:18713 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab3EXBTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 21:19:02 -0400
X-Spam-Score: -100.8
Message-ID: <519EBFD2.60105@asianux.com>
Date: Fri, 24 May 2013 09:18:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: jason.wessel@windriver.com, sasha.levin@oracle.com,
        vincent.stehle@laposte.net, john.blackwood@ccur.com,
        kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/debug/kdb: code enhancement for 3 areas.
References: <5194C23A.3090405@asianux.com> <20130523172849.GB30160@teo>
In-Reply-To: <20130523172849.GB30160@teo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 01:28 AM, Anton Vorontsov wrote:
> On Thu, May 16, 2013 at 07:25:46PM +0800, Chen Gang wrote:
>> > Delete waste '{' for 'case' statement.
>> > 
>> > For the return variable 'long res' in function kdb_task_state_string(),
>> > neither it matches the function return type 'unsigned long', nor is
>> > suitable as a flag variable to make 'or' operation. So use 'unsigned
>> > long' instead of 'long'.
>> > 
>> > If "case 'A'" happen in function kdb_task_state_string(), can return
>> > ~0UL directly to save the useless looping.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> If anything, these should be 3 separate patches...
> 

OK, I will separate them into 3 patches (originally, I think for trivial
cleanup patches, better let them in one patch, so can save the reviewers
and appliers time)

Excuse me, I have to do something else, so I will finish them within
this month (2013-05-31)


Thanks.
-- 
Chen Gang

Asianux Corporation
