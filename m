Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab3LIGWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:22:05 -0500
Received: from ozlabs.org ([203.10.76.45]:43794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760758Ab3LIGVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:21:48 -0500
In-Reply-To: <1386153162-11225-11-git-send-email-khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        khandual@linux.vnet.ibm.com
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: mikey@neuling.org, ak@linux.intel.com, eranian@google.com,
        acme@ghostprotocols.net, sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 10/10] powerpc, perf: Cleanup SW branch filter list look up
Message-Id: <20131209062147.B874D2C00C6@ozlabs.org>
Date: Mon,  9 Dec 2013 17:21:47 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-12 at 10:32:42 UTC, Anshuman Khandual wrote:
> This patch adds enumeration for all available SW branch filters
> in powerpc book3s code and also streamlines the look for the
> SW branch filter entries while trying to figure out which all
> branch filters can be supported in SW.

This appears to patch code that was only added in 8/10 ?

Was there any reason not to do it the right way from the beginning?

cheers
