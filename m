Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbaISQXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:23:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33425 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756553AbaISQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:23:16 -0400
Message-ID: <541C5861.4040403@fb.com>
Date: Fri, 19 Sep 2014 12:22:57 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Move BTRFS RCU string to common library
References: <cover.1411116672.git.osandov@osandov.com> <20140919154546.GZ4723@linux.vnet.ibm.com> <541C5029.1070500@fb.com> <20140919160555.GD4723@linux.vnet.ibm.com>
In-Reply-To: <20140919160555.GD4723@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-19_07:2014-09-19,2014-09-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=1 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409190138
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 12:05 PM, Paul E. McKenney wrote:
> On Fri, Sep 19, 2014 at 11:47:53AM -0400, Chris Mason wrote:
>>
>>
>> On 09/19/2014 11:45 AM, Paul E. McKenney wrote:
>>> On Fri, Sep 19, 2014 at 02:01:28AM -0700, Omar Sandoval wrote:
>>>> This patch series moves the generic RCU string library used internally by BTRFS
>>>> to be accessible by anyone. It provides printk_in_rcu and
>>>> printk_ratelimited_in_rcu to print these strings. In order to avoid a weird
>>>> inconsistency between the two, the first patch fixes printk_ratelimited so it
>>>> passes on the return value from printk.
>>>>
>>>> The second patch actually moves the RCU string library. Version 2 passes on the
>>>> return values from printk{,_ratelimited} and fixes some style issues.
>>>>
>>>> Omar Sandoval (2):
>>>
>>> For the series:
>>>
>>> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
>> Fine by me too, Paul, do you want to merge it in?
> 
> I would be happy to.
> 
> Are you thinking in terms of 3.18 or 3.19?  These look OK either way, but
> thought I should check.

Either way is fine with me.  Actually this will have minor conflicts
with my current branch headed for-next, so I can resolve and send as a
stand alone pull.

-chris

