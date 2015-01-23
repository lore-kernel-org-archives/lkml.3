Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbbAWDGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:06:35 -0500
Received: from ozlabs.org ([103.22.144.67]:57574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbbAWDGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:06:33 -0500
Message-ID: <1421982392.24984.9.camel@ellerman.id.au>
Subject: Re: [PATCH v2 1/2] powerpc: Add helpers for LPCR PECE1 operations
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Fri, 23 Jan 2015 14:06:32 +1100
In-Reply-To: <1421654727-31656-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1421654727-31656-1-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-19 at 13:35 +0530, Shreyas B. Prabhu wrote:
> PECE1 bit in LPCR is used to control whether decrementer can cause exit
> from powersaving states. PECE1 bit is cleared before entering fastsleep
> or deeper powersaving state and it is set on waking up. Since both
> cpuidle and cpu offline operations use these powersaving states, add
> helper functions to be used in both these places.

Thanks.

That isn't really much clearer than the original, so in the end I just merged
your original fix.

I'll think if there's a bigger consolidation we can do that makes it clearer.

cheers


