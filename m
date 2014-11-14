Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965834AbaKNSxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:53:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52988 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965580AbaKNSxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:53:33 -0500
Date: Fri, 14 Nov 2014 19:53:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141114185323.GG7475@pd.tnic>
References: <20141112220058.GA5295@redhat.com>
 <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
 <20141114103406.GA7475@pd.tnic>
 <CALCETrXTxJnEejqV_LjrDHO6Pur5afhYERneZD+2KrshH28tVQ@mail.gmail.com>
 <20141114172404.GF7475@pd.tnic>
 <CALCETrWJr_sMuKtYWF+CLnG7jDRxV7sgPvEQbtUhRokJquyq_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWJr_sMuKtYWF+CLnG7jDRxV7sgPvEQbtUhRokJquyq_g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 09:26:26AM -0800, Andy Lutomirski wrote:
> I was hoping for an actual worked-out example of what the parameters
> should be :)

Sorry, I haven't played with this myself either - haven't had a box with
EINJ yet. Maybe Tony has something.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
