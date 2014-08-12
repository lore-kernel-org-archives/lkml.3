Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaHLVgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:36:24 -0400
Received: from mail0.unitn.it ([193.205.194.10]:54412 "EHLO mail0.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaHLVgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:36:22 -0400
X-Greylist: delayed 831 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2014 17:36:22 EDT
Date: Tue, 12 Aug 2014 23:22:19 +0200
From: luca abeni <luca.abeni@unitn.it>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Documentation/scheduler/sched-deadline.txt: improve
 and clarify AC bits
Message-ID: <20140812232219.4a7b4255@utopia>
In-Reply-To: <53EA58B4.8050307@infradead.org>
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com>
	<1407858555-14371-4-git-send-email-juri.lelli@arm.com>
	<53EA58B4.8050307@infradead.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014 11:11:00 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:
[...]
> > + The utilisation of a real-time task is defined as the ratio
> > between its
> > + wcet and its period (or minimum inter-arrival time), and
> > represents
> 
>    "wcet" seems to be used here without any explanation of what it
> means.
Sorry, this should have been "WCET" (Worst Case Execution Time), which
is defined few lines above. I'll fix the typo (together with the other
issues that have been pointed out).

			Thanks,
				Luca
