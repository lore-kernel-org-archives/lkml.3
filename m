Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3JCQvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:51:51 -0400
Received: from imap.thunk.org ([74.207.234.97]:41742 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab3JCQvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:51:49 -0400
Date: Thu, 3 Oct 2013 12:51:30 -0400
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
Message-ID: <20131003165130.GA11974@thunk.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 05:52:33PM +0300, Stanimir Varbanov wrote:
> This patch set adds hardware RNG driver wich is used to control the
> Qualcomm's PRNG hardware block.
> The first patch document the DT bindings needed to sucessfuly probe
> the driver and the second patch adds the driver.

Is this really a PRNG (pseudo-random number generator)?  What are the
guarantees which Qualcomm is providing for the PRNG?  If it's really a
PRNG such as AES(i++, NSA_KEY), then kudo to Qualcomm for being
honest.

If it is supposed to be (or at least claimed to be) a secure random
number generator ala RDRAND suitable for use in cryptographic
applications, calling it a PRNG is going to be a bit misleading.

Cheers,

						- Ted
