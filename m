Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaEBUHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:07:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:51041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaEBUHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,974,1389772800"; 
   d="scan'208";a="426935221"
Message-ID: <5363FB05.4000302@intel.com>
Date: Fri, 02 May 2014 13:07:33 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>	<CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com> <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
In-Reply-To: <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 12:51 PM, Linus Torvalds wrote:
> On Fri, May 2, 2014 at 12:31 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Also, are you *really* sure that "popf" has the same one-instruction
>> interrupt shadow that "sti" has? Because I'm not at all sure that is
>> true, and it's not documented as far as I can tell. In contrast, the
>> one-instruction shadow after "sti" very much _is_ documented.
> 
> Yeah, I'm pretty sure about this. The only instructions with an
> interrupt shadow are "sti", "mov ss" and "pop ss".
> 

I believe you are correct here.

	-hpa

