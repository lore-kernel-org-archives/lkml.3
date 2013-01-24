Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3AXRQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:16:00 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45216 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3AXRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:15:58 -0500
Date: Thu, 24 Jan 2013 18:15:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3, v2] x86: xor-block handling adjustments
Message-ID: <20130124171554.GC11772@gmail.com>
References: <5093E40902000078000A6147@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5093E40902000078000A6147@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> v2 of this series is merely updated on top of the changes between
> 3.6 and 3.7-rc (which includes the dropping of what previously was
> the second patch in a four patch series).
> 
> 1: unify SSE-base xor-block routines
> 2: add alternative SSE implementation only prefetching once per 64-byte line
> 3: make virtualization friendly
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Looks useful. Wondering what the status is: hpa, was your 
concern resolved, do you think we can apply these?

Thanks,

	Ingo
