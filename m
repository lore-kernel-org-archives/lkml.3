Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaKYRqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:46:16 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63522 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaKYRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:46:10 -0500
Message-ID: <1416937564.3512.15.camel@maggy.simpson.net>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, peterz@infradead.org, riel@redhat.com,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Date: Tue, 25 Nov 2014 10:46:04 -0700
In-Reply-To: <54749725.3050307@oracle.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <alpine.DEB.2.11.1411242317380.6439@nanos>
	 <1416889208.4335.127.camel@maggy.simpson.net> <54749725.3050307@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 07:50 -0700, Khalid Aziz wrote:

> It is definitely not an attempt to solve any kind of RT problem.

No no, I'm saying that giving certain tasks special dispensations
effectively elevates them.  Temporarily or otherwise, they play by
different rules, will block more deserving tasks, and it's not cut and
dried that that blocking will not do more harm than good.

Is it a clear win to make say some kworker or other global asset wait
when it could have preempted and been gone in usecs?  Nope.

	-Mike

