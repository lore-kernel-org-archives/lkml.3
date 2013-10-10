Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3JJKmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:42:22 -0400
Received: from ozlabs.org ([203.10.76.45]:48500 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab3JJKmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:42:19 -0400
Date: Thu, 10 Oct 2013 21:41:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Qualcomm's PRNG
Message-ID: <20131010104140.GE9906@iris.ozlabs.ibm.com>
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com>
 <20131003165130.GA11974@thunk.org>
 <524EEB96.6040707@mm-sol.com>
 <20131004181005.GA7022@thunk.org>
 <52556C4E.9000604@mm-sol.com>
 <52557137.5050200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52557137.5050200@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 08:07:35AM -0700, H. Peter Anvin wrote:

> consider the PowerPC random number generator[1]) and

[snip]

> [1] which has a known first-order bias which they "correct" for by
> XORing two datums together in a very simple data reduction step.

65 actually, not two.

> However, if their random source has bias it is extremely likely it also
> has nonzero correlations, which require stronger reductions.  It would

The correlations are essentially zero, by design, and experiment
confirms it.  Did you see my mail on the kvm list where I explained
how it works?

Paul.
