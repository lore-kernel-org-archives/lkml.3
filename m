Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaBNO50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:57:26 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35908 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBNO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:57:25 -0500
Message-ID: <52FE2EAB.4070304@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 09:56:43 -0500
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Subject: Warning in workqueue.c
References: <52F4F01C.1070800@linux.vnet.ibm.com> <20140207165113.GD3304@htj.dyndns.org> <52F51E10.8050208@linux.vnet.ibm.com> <20140207193604.GA8833@htj.dyndns.org> <52F8F0FB.3080206@linux.vnet.ibm.com> <20140210231742.GK25350@mtj.dyndns.org> <52FB90C6.4010701@linux.vnet.ibm.com> <52FC3C83.8020303@cn.fujitsu.com> <52FD07B2.5080402@linux.vnet.ibm.com> <20140213204102.GC17608@htj.dyndns.org>
In-Reply-To: <20140213204102.GC17608@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021414-0928-0000-0000-0000065E32E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 03:41 PM, Tejun Heo wrote:

> Jason, I don't have much idea from workqueue side.  Have you been
> running this test with older kernels too?  Can you confirm whether
> this failure is something recent?  Bisection would be awesome but just
> confirming, say, 3.12 doesn't have this issue would be very helpful.

I will try to find a kernel where this is not reproducible and attempt
bisect from there. I will let you know what I find.

-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

