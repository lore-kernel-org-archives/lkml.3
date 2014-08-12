Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaHLTRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:17:33 -0400
Received: from imap.thunk.org ([74.207.234.97]:56855 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbaHLTRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:17:31 -0400
Date: Tue, 12 Aug 2014 15:17:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm list <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get
 some from kvm
Message-ID: <20140812191723.GI12871@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	kvm list <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
References: <cover.1406177531.git.luto@amacapital.net>
 <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 12:11:29PM -0700, Andy Lutomirski wrote:
> 
> What's the status of this series?  I assume that it's too late for at
> least patches 2-5 to make it into 3.17.

Which tree were you hoping this patch series to go through?  I was
assuming it would go through the x86 tree since the bulk of the
changes in the x86 subsystem (hence my Acked-by).

IIRC, Peter had some concerns, and I don't remember if they were all
addressed.  Peter?

						- Ted
