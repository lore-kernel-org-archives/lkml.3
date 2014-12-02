Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaLBFhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:37:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:16624 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaLBFhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:37:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,498,1413270000"; 
   d="scan'208";a="646656188"
Date: Tue, 2 Dec 2014 13:16:46 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>, hpa@linux.intel.com
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
Message-ID: <20141202051646.GA3417@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <20141125101331.GA28985@kernel>
 <54745BB0.8080304@redhat.com>
 <400361E2-995A-44B4-B35A-0D35793B49DD@gmail.com>
 <54748F70.70402@redhat.com>
 <DEE91387-BFE2-4F83-9711-25B2B65CF655@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEE91387-BFE2-4F83-9711-25B2B65CF655@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Tue, Nov 25, 2014 at 04:50:06PM +0200, Nadav Amit wrote:
[...]
>I am just worried that Wanpeng reported it fails, while I report it works...

I just get a real skylake-client machine on hand, both the two patches from 
you can run normally, it seems that the silly emulator which I used is buggy. 
Sorry for the false report. In addition, I send out the xsaves enable patch 
for kvm, it can work w/ your patch 2/2 correctly.

Regards,
Wanpeng Li 
