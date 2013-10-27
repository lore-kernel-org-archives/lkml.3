Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3J0MDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:03:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3J0MDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:03:37 -0400
Date: Sun, 27 Oct 2013 05:04:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        handai.szj@taobao.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] percpu counter: cast this_cpu_sub() adjustment
Message-Id: <20131027050429.7fcc2ed5.akpm@linux-foundation.org>
In-Reply-To: <20131027112255.GB14934@mtj.dyndns.org>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
	<1382859876-28196-3-git-send-email-gthelen@google.com>
	<20131027112255.GB14934@mtj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct 2013 07:22:55 -0400 Tejun Heo <tj@kernel.org> wrote:

> We probably want to cc stable for this and the next one.  How should
> these be routed?  I can take these through percpu tree or mm works
> too.  Either way, it'd be best to route them together.

Yes, all three look like -stable material to me.  I'll grab them later
in the week if you haven't ;)

The names of the first two patches distress me.  They rather clearly
assert that the code affects percpu_counter.[ch], but that is not the case. 
Massaging is needed to fix that up.


