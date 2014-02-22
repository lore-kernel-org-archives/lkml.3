Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaBVThU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:37:20 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58789 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaBVThS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:37:18 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 22 Feb 2014 11:37:04 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, Feng Tang <feng.tang@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jacob Shin <jacob.shin@amd.com>,
        Jan Beulich <JBeulich@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Rob Landley <rob@landley.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/2] x86: Support compiling out human-friendly processor
 feature names
Message-ID: <20140222193704.GA12698@thin>
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org>
 <33fa63a2b441f81f2ddb3ee2edff4deda60e50ac.1393096111.git.josh@joshtriplett.org>
 <3a74c95c-45be-41c1-8bca-aa92773f86b4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a74c95c-45be-41c1-8bca-aa92773f86b4@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 11:16:57AM -0800, H. Peter Anvin wrote:
> Is the goal here to shrink bzImage or the runtime kernel?

Both, though I primarily care about the former.

> Also, there are eay too many ifdefs in this patch.  You don't have to
> conditionalize the rules to build things, just don't include them if
> not needed.

Fixed in v2.

- Josh Triplett
