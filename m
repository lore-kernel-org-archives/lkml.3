Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbaENO1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:27:14 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:53353 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaENO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:27:12 -0400
Message-ID: <1400077624.9356.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning
 of the rwsem's count field
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com,
        jason.low2@hp.com, riel@redhat.com, alex.shi@linaro.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, walken@google.com
Cc: linux-tip-commits@vger.kernel.org
Date: Wed, 14 May 2014 07:27:04 -0700
In-Reply-To: <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
References: <1399060437.2970.146.camel@schen9-DESK>
	 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 01:46 -0700, tip-bot for Tim Chen wrote:
> Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> Author:     Tim Chen <tim.c.chen@linux.intel.com>
> AuthorDate: Fri, 2 May 2014 12:53:57 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sun, 4 May 2014 20:34:26 +0200
> 
> rwsem: Add comments to explain the meaning of the rwsem's count field
> 
> It took me quite a while to understand how rwsem's count field
> mainifested itself in different scenarios.
> 
> Add comments to provide a quick reference to the the rwsem's count
> field for each scenario where readers and writers are contending
> for the lock.
> 
> Hopefully it will be useful for future maintenance of the code and
> for people to get up to speed on how the logic in the code works.

sigh, after this commit, the opt spin patch no longer applies, I'm
rebasing and send out v5.

