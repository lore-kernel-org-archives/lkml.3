Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3EOUTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:19:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:47686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab3EOUTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:19:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,679,1363158000"; 
   d="scan'208";a="242095634"
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
	<1368494338-7069-18-git-send-email-koverstreet@google.com>
Date: Wed, 15 May 2013 13:19:37 -0700
In-Reply-To: <1368494338-7069-18-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Mon, 13 May 2013 18:18:54 -0700")
Message-ID: <m2zjvw2dye.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> Allocates integers out of a predefined range - for use by e.g. a driver
> to allocate tags for communicating with the device.

Can this really not be merged with idr.c ? 

Would a idr per cpu do?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
