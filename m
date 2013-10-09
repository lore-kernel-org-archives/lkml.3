Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3JIOr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:47:58 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:48373 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab3JIOry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:47:54 -0400
Message-ID: <52556C4E.9000604@mm-sol.com>
Date: Wed, 09 Oct 2013 17:46:38 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Qualcomm's PRNG
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <20131003165130.GA11974@thunk.org> <524EEB96.6040707@mm-sol.com> <20131004181005.GA7022@thunk.org>
In-Reply-To: <20131004181005.GA7022@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On 10/04/2013 09:10 PM, Theodore Ts'o wrote:
> On Fri, Oct 04, 2013 at 07:23:50PM +0300, Stanimir Varbanov wrote:
>> I guess that it should follow NIST 800-90 recommendation, but I'm not
>> aware what DRBG mechanism is used.
>>
>> To be honest I really don't know the hardware implementation details. I
>> put PRNG abbreviation in the cover letter just because I saw that
>> defines for register offsets are prefixed with PRNG_*. I could rename
>> all occurrences of PRNG to RNG. Is that will be enough to avoid confusions?
> 
> If that's what the Qualcomm documentation uses, maybe we should stick
> with it, and add some explanatory comments.  Is there any
> documentation for this block that is public that you can either send
> me a a pointer to?

No, there is no public documentation for the block. Here is the driver
documentation which I used as a base [1].

My guess was that - if it is PRNG (got from hardware description link
above) than according to wiki [2] it is also known as a deterministic
random bit generator (DRBG). The recommendation for RNG using DRBG is
NIST 800-90.

Of course I could be wrong, so I can add a comment that this is just a
guess and we shouldn't over-reliance on this.

regards,
Stan

[1]
https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/Documentation/arm/msm/msm_rng-driver.txt?h=jb_3.2.1

[2] http://en.wikipedia.org/wiki/Pseudorandom_number_generator
