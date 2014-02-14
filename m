Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaBNO6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:58:21 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62346 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBNO6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:58:19 -0500
MIME-Version: 1.0
In-Reply-To: <52FE2EAB.4070304@linux.vnet.ibm.com>
References: <52F4F01C.1070800@linux.vnet.ibm.com>
	<20140207165113.GD3304@htj.dyndns.org>
	<52F51E10.8050208@linux.vnet.ibm.com>
	<20140207193604.GA8833@htj.dyndns.org>
	<52F8F0FB.3080206@linux.vnet.ibm.com>
	<20140210231742.GK25350@mtj.dyndns.org>
	<52FB90C6.4010701@linux.vnet.ibm.com>
	<52FC3C83.8020303@cn.fujitsu.com>
	<52FD07B2.5080402@linux.vnet.ibm.com>
	<20140213204102.GC17608@htj.dyndns.org>
	<52FE2EAB.4070304@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 09:58:18 -0500
X-Google-Sender-Auth: ZusC5f3CfVjRtxSQUX1vc_nig-A
Message-ID: <CAOS58YP_dEni2E32RRQKVsiGRg9EUJdt6q3swRM4KPyns0P2aw@mail.gmail.com>
Subject: Re: Subject: Warning in workqueue.c
From: Tejun Heo <tj@kernel.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jason.

On Fri, Feb 14, 2014 at 9:56 AM, Jason J. Herne
<jjherne@linux.vnet.ibm.com> wrote:
> I will try to find a kernel where this is not reproducible and attempt
> bisect from there. I will let you know what I find.

Yes, even just finding that there's an earlier version where this
doesn't happen would be great.

Thank you very much.

-- 
tejun
