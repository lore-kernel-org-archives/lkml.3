Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3JDSKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:10:24 -0400
Received: from imap.thunk.org ([74.207.234.97]:42174 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3JDSKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:10:22 -0400
Date: Fri, 4 Oct 2013 14:10:05 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
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
Message-ID: <20131004181005.GA7022@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-arm-msm@vger.kernel.org
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com>
 <20131003165130.GA11974@thunk.org>
 <524EEB96.6040707@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524EEB96.6040707@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 07:23:50PM +0300, Stanimir Varbanov wrote:
> I guess that it should follow NIST 800-90 recommendation, but I'm not
> aware what DRBG mechanism is used.
> 
> To be honest I really don't know the hardware implementation details. I
> put PRNG abbreviation in the cover letter just because I saw that
> defines for register offsets are prefixed with PRNG_*. I could rename
> all occurrences of PRNG to RNG. Is that will be enough to avoid confusions?

If that's what the Qualcomm documentation uses, maybe we should stick
with it, and add some explanatory comments.  Is there any
documentation for this block that is public that you can either send
me a a pointer to?

Thanks,

					- Ted
