Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaEAVBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:01:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40685 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbaEAVBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:01:32 -0400
Message-ID: <5362B618.50602@zytor.com>
Date: Thu, 01 May 2014 14:01:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Subject: Re: random: Providing a seed value to VM guests
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com> <20140501192618.GA25829@thunk.org> <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com> <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com> <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com> <20140501203910.GB25829@thunk.org> <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com>
In-Reply-To: <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 01:56 PM, Andy Lutomirski wrote:
> 
> Even if we could emulate RDSEED effectively**, I don't really
> understand what the guest is expected to do with it.  And I generally
> dislike defining an interface with no known sensible users, because it
> means that there's a good chance that the interface won't end up
> working.
>
> ** Doing this sensibly in the host will be awkward.  Is the host
> supposed to use non-blocking reads of /dev/random?  Getting anything
> remotely fair may be difficult.

The host can use nonblocking reads of /dev/random.  Fairness would have
to be implemented at the host level, but that is true for anything.

	-hpa


