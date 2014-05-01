Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaEAWSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:18:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:46293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaEAWSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:18:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,967,1389772800"; 
   d="scan'208";a="426555392"
Date: Thu, 1 May 2014 15:18:36 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
Message-ID: <20140501221836.GI19657@tassilo.jf.intel.com>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-5-git-send-email-andi@firstfloor.org>
 <535FED4D.5000703@amacapital.net>
 <20140429233950.GE2382@two.firstfloor.org>
 <53608180.5070800@zytor.com>
 <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com>
 <20140501211554.GH2382@two.firstfloor.org>
 <5362C37E.2090603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5362C37E.2090603@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I haven't looked through the flows (I'm at LCE so I have limited screen
> bandwidth) to see how that would be handled in this case, but in the
> general paranoid case it comes down to the fact that in this particular
> subcase we don't necessarily know exactly how many SWAPGS are between us
> and userspace after we IRET.

There is none as far as I know. Certainly wasn't any when the code
was originally written.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
