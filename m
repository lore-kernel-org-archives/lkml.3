Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaIEVqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:46:09 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48470 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaIEVqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:46:07 -0400
Message-ID: <540A2F15.5070603@redhat.com>
Date: Fri, 05 Sep 2014 23:45:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM changes for 3.17-rc4
References: <1409912186-22968-1-git-send-email-pbonzini@redhat.com> <CA+55aFxum+O9j4ohV=BwJR_+q+hMAZ2QLp0SpgZzYFWs9F=EUg@mail.gmail.com> <alpine.DEB.2.10.1409052254450.5472@nanos> <540A267E.1070002@redhat.com> <alpine.DEB.2.10.1409052314330.5472@nanos>
In-Reply-To: <alpine.DEB.2.10.1409052314330.5472@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/09/2014 23:24, Thomas Gleixner ha scritto:
> 
>> > that besides acting as a workaround, I find the patched code easier to
>> > understand, and I clearly stated the same in the tag message.
> Well, we might have different opinions about easier to understand. I
> did go a great length to distangle the monotonic boot time on which
> you are interested from xtime, because the latter does not make any
> sense outside of the core timekeeping code. Aside of that I optimized
> the whole thing to avoid conversions, loops and hoops. So you just add
> another multiply and add to make it more understandable. 

Fair enough, I've dropped the patch.

Thanks for helping out with the core timekeeping fix.

Paolo
