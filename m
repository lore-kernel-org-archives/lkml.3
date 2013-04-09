Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458Ab3DII4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:56:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47356
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935272Ab3DII4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:56:05 -0400
Message-ID: <1365497753.2609.163.camel@laptop>
Subject: Re: [PATCH v4] sched: fix wrong rq's runnable_avg update with rt
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, pjt@google.com, rostedt@goodmis.org,
        fweisbec@gmail.com, efault@gmx.de
Date: Tue, 09 Apr 2013 10:55:53 +0200
In-Reply-To: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
References: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 16:15 +0200, Vincent Guittot wrote:
> Changes since V2:
> - remove useless definition for UP platform
> - rebased on top of Steven Rostedt's patches :
> https://lkml.org/lkml/2013/2/12/558

So what's the status of those patches? I still worry about the extra
context switch overhead for the high-frequency idle scenario.

