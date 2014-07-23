Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbaGWVTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:19:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:25305 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933170AbaGWVS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:18:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,719,1400050800"; 
   d="scan'208";a="574425521"
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
Date: Wed, 23 Jul 2014 14:18:58 -0700
In-Reply-To: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 22 Jul 2014 17:10:57 -0700")
Message-ID: <8738drrcxp.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> I think an MCE just might be okay -- it's not
> really recoverable anyway. 

That's wrong.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
