Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaKLMGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:06:18 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35977 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752874AbaKLMGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:06:16 -0500
Date: Wed, 12 Nov 2014 12:05:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org,
        "keescook@chromium.org" <keescook@chromium.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Message-ID: <20141112120549.GA4042@n2100.arm.linux.org.uk>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
 <54633F53.8020507@linaro.org>
 <20141112111352.GC26437@arm.com>
 <6358312.yt5WU3kBm9@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6358312.yt5WU3kBm9@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 12:19:26PM +0100, Arnd Bergmann wrote:
> On Wednesday 12 November 2014 11:13:52 Will Deacon wrote:
> > Just do arm64. We already have the dedicated request for arch/arm/.
> 
> I wonder if we should define NT_ARM64_SYSTEM_CALL to the same value
> as NT_S390_SYSTEM_CALL (0x307), or even define it as an architecture-
> independent NT_SYSTEM_CALL number with that value, so other architectures
> don't have to introduce new types when they also want to implement it.

That would be a sane thing to do, so that tools which want to get at
this information can do in an almost standardised way for architectures
implementing this method.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
