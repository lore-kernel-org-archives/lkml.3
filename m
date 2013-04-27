Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3D0Cqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 22:46:44 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43840 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3D0Cqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 22:46:43 -0400
Message-ID: <517B3C07.1020004@linux.vnet.ibm.com>
Date: Sat, 27 Apr 2013 10:46:31 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1366626208.2721.12.camel@laptop>
In-Reply-To: <1366626208.2721.12.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042702-6102-0000-0000-000003648DE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 06:23 PM, Peter Zijlstra wrote:
> 
> OK,.. Ingo said that pipe-test was the original motivation for
> wake_affine() and since that's currently broken to pieces due to
> select_idle_sibling() is there still a benefit to having it at all?
> 
> Can anybody find any significant regression when simply killing
> wake_affine()?

Is it time for us to make the decision now?

Forgive me for urge the progress, but I really confused what is stopping
us from adopt the throttle approach...

Is there any other option more simple, safe and faster?

Regards,
Michael Wang

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

