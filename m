Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3IZBQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:16:35 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45851 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3IZBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:16:34 -0400
Date: Thu, 26 Sep 2013 09:16:17 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@redhat.com
Subject: Re: [PATCH] perf: fix two warning in bench/numa
Message-ID: <20130926011617.GA6802@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20130925073515.GA7053@weiyang.vnet.ibm.com>
 <20130925112629.GB29884@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925112629.GB29884@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092601-5140-0000-0000-000003E43BB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 01:26:29PM +0200, Ingo Molnar wrote:
>
>* Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
>
>> Hi, all
>> 
>> Any comments on this one? 
>> 
>> These two warnings will break the compile of perf under 32-bit machine.
>
>fix looks good to me.

Thanks for your comments :-)

>
>> >-			if (diff.tv_sec >= g->p.nr_secs) {
>> >+			if (diff.tv_sec >= (time_t)g->p.nr_secs) {
>
>> >-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
>> >+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016"PRIu64"]\n",
>
>Acked-by: Ingo Molnar <mingo@kernel.org>
>
>Thanks,
>
>	Ingo

-- 
Richard Yang
Help you, Help me

