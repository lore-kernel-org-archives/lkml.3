Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab3BNPPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:15:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3BNPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:15:01 -0500
Date: Thu, 14 Feb 2013 15:09:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Mircea Gherzan <mgherzan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: net: bpf_jit: fix emit_swap16() for non ARMv6+.
Message-ID: <20130214150925.GI17833@n2100.arm.linux.org.uk>
References: <1360776125-14542-1-git-send-email-nschichan@freebox.fr> <1360776645-14726-1-git-send-email-nschichan@freebox.fr> <511C0662.8010309@gmail.com> <511CE939.5000705@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511CE939.5000705@freebox.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:40:09PM +0100, Nicolas Schichan wrote:
> On 02/13/2013 10:32 PM, Mircea Gherzan wrote:
> [...]
>> Acked-by: Mircea Gherzan <mgherzan@gmail.com>
>
> Hi,
>
> Thanks Mircea. Russel, David, do you have any preference as to which path 
> this patch should take (net tree or ARM tree) ?

I'm happy for either - I'm under the weather at the moment, so I'd be
greatful if David could pick this one up this time around.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
