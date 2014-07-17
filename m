Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaGQRcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:32:47 -0400
Received: from imap.thunk.org ([74.207.234.97]:41416 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbaGQRcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:32:45 -0400
Date: Thu, 17 Jul 2014 13:32:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
Message-ID: <20140717173230.GP1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
	Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
	kvm list <kvm@vger.kernel.org>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Daniel Borkmann <dborkman@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>
References: <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
 <53C6F5A9.80400@zytor.com>
 <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com>
 <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com>
 <53C703ED.2010605@zytor.com>
 <CALCETrVSG_Lp=OSw-U+QK+_VsEhKBS=rBQ3ojTrnO9kAKR+Qag@mail.gmail.com>
 <53C75733.8060507@zytor.com>
 <20140717103324.GJ1491@thunk.org>
 <53C7FC32.7030704@zytor.com>
 <CALCETrVgCw2_8x1+NrP_xO4ZtnFm_dTTUBtZd-tgfdWgfeu2FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVgCw2_8x1+NrP_xO4ZtnFm_dTTUBtZd-tgfdWgfeu2FQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:12:27AM -0700, Andy Lutomirski wrote:
> 
> Unless I'm reading the code wrong, the prandom_reseed_late call can
> happen after userspace is running.

But there is also the prandom_reseed() call, which happens early.

    	     	      		       	     	   	   - Ted
