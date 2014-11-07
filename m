Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaKGUXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:23:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27710 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbaKGUXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:23:18 -0500
Date: Fri, 7 Nov 2014 15:21:29 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v5] Move BTRFS RCU string to common library
To: Omar Sandoval <osandov@osandov.com>
CC: Josef Bacik <jbacik@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Message-ID: <1415391689.9491.0@mail.thefacebook.com>
In-Reply-To: <1415391451-19108-1-git-send-email-osandov@osandov.com>
References: <1415391451-19108-1-git-send-email-osandov@osandov.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-07_08:2014-11-07,2014-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411070166
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 7, 2014 at 3:17 PM, Omar Sandoval <osandov@osandov.com> 
wrote:
> The RCU-friendly string API used internally by BTRFS is generic 
> enough for
> common use. This doesn't add any new functionality, but instead just 
> moves the
> code and documents the existing API.
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> Chris, could you take a look at this again? It's just been rebased 
> and should
> be good to go. Thanks!

Thanks Omar, I'm pulling this into a branch for the next merge window.  
Looks good to me.

-chris


