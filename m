Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315Ab3IEGgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 02:36:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab3IEGgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 02:36:44 -0400
Message-ID: <1378362989.18435.2.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        yinghai@kernel.org, joe.jin@oracle.com
Date: Thu, 05 Sep 2013 08:36:29 +0200
In-Reply-To: <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <20130729115701.GD3008@twins.programming.kicks-ass.net>
	 <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:GBdr3daxOClhAiWIClr8gmgGssWFb3FVqO1nZmZj+Mn
 QU3Q8vjtMkeEj0o0aRJOrRNOCvGAD0Kjw6XjyL7z8qRMCUAoM6
 1drB9E0SR9DLMsYALlHkpKAWRp2dQ4TaQ3pqyBHR7uUTAMlUmf
 hD5nC/r61qbKARqXKCOFgBHaF7QDjrpeoTr4W7pYy7iafFWojF
 VG43eXifep7DlgvNCs/HzLv3yZ9EdGYrP4IkEqGYJ8UoAicJy2
 euisQgVxCUlDhmLLdHR7mtF4JTqxb0pAQPRpiSxrDIifxh1QLS
 8NrQ3YrcBIuzryGSsks+Wu04p1fZxMGQE4FR42vGgSHIQao4+3
 sFb9p4yFg3PdiUzI1YR2G545NyR+TKceKeKqogCmWhM/LE4Kng
 hCE/pMxJNYnrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 15:32 +0800, ethan.zhao wrote:

...

> That is great improvement, So it is worth to merge.

It didn't swim upstream for some reason.

-Mike

