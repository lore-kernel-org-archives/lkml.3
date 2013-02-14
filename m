Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826Ab3BNS1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:27:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58697 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab3BNS1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:27:11 -0500
Date: Thu, 14 Feb 2013 13:27:07 -0500 (EST)
Message-Id: <20130214.132707.316192073342955090.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: nschichan@freebox.fr, mgherzan@gmail.com, daniel.borkmann@tik.ee.ethz.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: net: bpf_jit: fix emit_swap16() for non ARMv6+.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130214150925.GI17833@n2100.arm.linux.org.uk>
References: <511C0662.8010309@gmail.com>
	<511CE939.5000705@freebox.fr>
	<20130214150925.GI17833@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Thu, 14 Feb 2013 15:09:25 +0000

> On Thu, Feb 14, 2013 at 02:40:09PM +0100, Nicolas Schichan wrote:
>> On 02/13/2013 10:32 PM, Mircea Gherzan wrote:
>> [...]
>>> Acked-by: Mircea Gherzan <mgherzan@gmail.com>
>>
>> Hi,
>>
>> Thanks Mircea. Russel, David, do you have any preference as to which path 
>> this patch should take (net tree or ARM tree) ?
> 
> I'm happy for either - I'm under the weather at the moment, so I'd be
> greatful if David could pick this one up this time around.
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Applied to 'net', thanks everyone.
