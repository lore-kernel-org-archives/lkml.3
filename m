Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab3KVUdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:33:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39361 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:33:19 -0500
Message-ID: <528FBF8A.4090207@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 15:33:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: oleg@redhat.com
CC: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        viro@ZenIV.linux.org.uk, keescook@chromium.org, mhocko@suse.cz,
        snanda@chromium.org, dserrg@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] kill task_struct->did_exec
References: <20131122175447.GA31463@redhat.com> <528FB49E.2000502@jp.fujitsu.com> <20131122203320.GA20250@redhat.com>
In-Reply-To: <20131122203320.GA20250@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/22/2013 3:33 PM), Oleg Nesterov wrote:
> On 11/22, KOSAKI Motohiro wrote:
>>
>> (11/22/2013 12:54 PM), Oleg Nesterov wrote:
>>> We can kill either task->did_exec or PF_FORKNOEXEC, they are
>>> mutually exclusive. The patch kill ->did_exec because it has
>>> a single user.
>>
>> It's ok.
>>
>> but,
>>
>>> - * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
>>> - * LBT 04.03.94
>>> + * !PF_FORKNOEXEC check to conform completely to POSIX. LBT 04.03.94.
>>
>> I guess LBT is his name and !PF_FORKNOEXEC is not his opinion. Please just
>> remove "LBT 04.03.94" too. git repo still keep his achievement and can avoid
>> confusion.
> 
> OK, please see v2.
> 
> 
> Subject: [PATCH] kill task_struct->did_exec
> From: Oleg Nesterov <oleg@redhat.com>
> Date: Fri, 22 Nov 2013 18:43:40 +0100
> 
> We can kill either task->did_exec or PF_FORKNOEXEC, they are
> mutually exclusive. The patch kills ->did_exec because it has
> a single user.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



