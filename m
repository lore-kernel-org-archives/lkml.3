Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab3BMNzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:55:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:42966 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3BMNzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:55:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="290589907"
Message-ID: <511B9B4F.3060404@intel.com>
Date: Wed, 13 Feb 2013 21:55:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, yuanhan.liu@linux.intel.com,
        dhowells@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] rwsem: Implement writer lock-stealing
References: <1360377937-16297-1-git-send-email-walken@google.com>
In-Reply-To: <1360377937-16297-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 10:45 AM, Michel Lespinasse wrote:
> This proposal implements writer lock stealing in lib/rwsem.c, just as
> Alex Shi's earlier proposal did for the simpler lib/rwsem-spinlock.c

Ops, my patch in tip/urgent is for rwsem. Yuanhan's patch is for
rwsem-spinlock.

Thanks
    Alex
