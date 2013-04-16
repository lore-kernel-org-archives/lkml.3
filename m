Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab3DPSPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:15:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45881 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3DPSPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:15:46 -0400
Message-ID: <516D9525.9060600@zytor.com>
Date: Tue, 16 Apr 2013 11:15:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH v2 0/6] kernel ASLR
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <CAGXu5jKjR46sZ4XnfzaJ0daNC82bqY2wdbTZn05Wz3v5hkP5BA@mail.gmail.com>
In-Reply-To: <CAGXu5jKjR46sZ4XnfzaJ0daNC82bqY2wdbTZn05Wz3v5hkP5BA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 11:08 AM, Kees Cook wrote:
> On Fri, Apr 12, 2013 at 1:13 PM, Kees Cook <keescook@chromium.org> wrote:
>> This splits up the relocs tool changes into the separate logical pieces,
>> which should be easier to review. I could use some suggestions on a
>> better way to build it in the 4th patch. What I have now seems ugly,
>> but Kbuild would not give me its secrets.
> 
> How does the relocation portion of this series look? It's separate
> from the ASLR logic, but required for it. Do those changes look good
> for the tip/kaslr tree?
> 

They are probably okay... I should take a closer look.

I might prioritize it down since (a) I am sick, and (b) it is the week
before the merge window.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

