Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbaFSRde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:33:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:17515 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295AbaFSRdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="558097565"
Date: Thu, 19 Jun 2014 10:33:26 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        peterz@infradead.org, gleb@kernel.org, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140619173326.GS8178@tassilo.jf.intel.com>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <20140610180448.GA9485@amt.cnet>
 <20140610192207.GC8178@tassilo.jf.intel.com>
 <20140610210654.GA16344@amt.cnet>
 <53A2F6E3.6020703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A2F6E3.6020703@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Userspace then can read/write these MSRs, and add them to the migration
> stream.  QEMU has code for that.

Thanks. The PEBS setup always redoes its state, can be arbitarily often redone.

So the only change needed would be to add the MSRs to some list in qemu?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
