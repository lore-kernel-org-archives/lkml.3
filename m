Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3LETSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:18:32 -0500
Received: from a9-92.smtp-out.amazonses.com ([54.240.9.92]:57629 "EHLO
	a9-92.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab3LETSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:18:31 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:18:31 EST
Date: Thu, 5 Dec 2013 19:13:11 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Oleg Nesterov <oleg@redhat.com>
cc: Tejun Heo <htejun@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
 ____call_usermodehelper()->set_cpus_allowed_ptr()
In-Reply-To: <20131205153016.GA20705@redhat.com>
Message-ID: <00000142c42d9708-c1154c9a-4265-45ee-971f-a6c8b5768ebf-000000@email.amazonses.com>
References: <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128142359.GA6420@redhat.com> <20131128143155.GC3925@htj.dyndns.org> <20131128150055.GA11956@redhat.com> <20131128150233.GA10022@twins.programming.kicks-ass.net> <20131128193330.GA24767@redhat.com>
 <20131128193349.GB24767@redhat.com> <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com> <20131205143745.GA18488@redhat.com> <20131205143903.GA3231@htj.dyndns.org> <20131205153016.GA20705@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.05-54.240.9.92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Oleg Nesterov wrote:

> Perhaps, I simply do not know what the users want.

We would like to control OS spawning of threads and restrict them to a
limited set of cpus so that the other processors can do latency sensitive
work without being impacted by creation of kernel threads etc.

