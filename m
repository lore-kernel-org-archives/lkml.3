Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaKFRBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:01:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaKFRBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:01:39 -0500
Date: Thu, 6 Nov 2014 17:01:18 +0000
From: Aaron Tomlin <atomlin@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [tracer branch] kernel BUG at kernel/sched/core.c:2697!
Message-ID: <20141106170118.GC23116@atomlin.usersys.redhat.com>
References: <20141103070608.GC1189@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141103070608.GC1189@wfg-t540p.sh.intel.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-03 15:06 +0800, Fengguang Wu wrote:
> Hi Aaron,
> 
> FYI your patch triggered a BUG on an existing old bug.

Oh right. Good to know :)

> Let's hope it provides more info to debug the problem.

Hopefully :)

-- 
Aaron Tomlin
