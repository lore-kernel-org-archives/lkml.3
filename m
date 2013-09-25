Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3IYPwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:52:50 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:35153 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab3IYPwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:52:49 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Rob Landley <rob@landley.net>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: new binutils needed for arm in 3.12-rc1
References: <1380122586.1974.84@driftwood>
Date: Wed, 25 Sep 2013 16:52:44 +0100
In-Reply-To: <1380122586.1974.84@driftwood> (Rob Landley's message of "Wed, 25
	Sep 2013 10:23:06 -0500")
Message-ID: <yw1x7ge4x5ir.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 09/24/2013 09:07:57 PM, Nicolas Pitre wrote:
>> I'd strongly suggest you make your binutils compatible with newer
>> instruction syntax instead of making the kernel more complex.
>
> Meaning I play whack-a-mole as this becomes permission to depend on  
> endless new gnuisms just because they're there and nobody else is  
> regression testing against them, not because they actually add anything.

Since when is assembling the instructions correctly, as specified in the
arch ref, and not in some other random way a gnuism?

-- 
Måns Rullgård
mans@mansr.com
