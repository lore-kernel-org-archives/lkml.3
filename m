Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaDKS3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:29:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46131 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbaDKS3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:29:45 -0400
Message-ID: <53483487.6030103@zytor.com>
Date: Fri, 11 Apr 2014 11:29:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
In-Reply-To: <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:27 AM, Brian Gerst wrote:
> Is this bug really still present in modern CPUs?  This change breaks
> running 16-bit apps in Wine.  I have a few really old games I like to
> play on occasion, and I don't have a copy of Win 3.11 to put in a VM.

It is not a bug, per se, but an architectural definition issue, and it
is present in all x86 processors from all vendors.

Yes, it does break running 16-bit apps in Wine, although Wine could be
modified to put 16-bit apps in a container.  However, this is at best a
marginal use case.

	-hpa

