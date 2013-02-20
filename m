Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab3BTIuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:50:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:31336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab3BTIuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:50:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="204344591"
Message-ID: <51248E59.2010907@intel.com>
Date: Wed, 20 Feb 2013 16:50:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        anton@samba.org, hpa@zytor.com, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] rwsem: Implement writer lock-stealing
References: <1360377937-16297-1-git-send-email-walken@google.com> <511B9B4F.3060404@intel.com> <20130213144932.GA14260@gmail.com> <CANN689FJcUZq1wcVZXO+jLOHOeCPnOf5kfYgYVykG6-YLSjj7g@mail.gmail.com>
In-Reply-To: <CANN689FJcUZq1wcVZXO+jLOHOeCPnOf5kfYgYVykG6-YLSjj7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Alex, could you go through my patch and see if there is anything you
> find objectionable ? (if not about the details, at least about the
> general approach of enabling writer lock stealing on the fast path)
> 

I did a quick review on the patchset and tested the patches 1~3, and 1~3
plus 4th, my patch plus 4th.

The patch looks much complicated, and also goes writing slow path to
steal locking. My patch looks quite straight and simple.

This 1~3 patch has very very similar performance effect with mine.

The highlight patch is the 4th, seems it can provide about ~2% aim7
performance gain(base on both of mine or patches 1~3) on my 4S NHM EX
machine.


-- 
Thanks Alex
