Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaHVPVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:21:17 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48052 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbaHVPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:21:16 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: usb: gadget: fusb300_udc.h: Fix typo in include guard
Organization: D03
References: <20140822140656.GB22707@saruman.home>
	<1408718673-2003-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140822144848.GF22707@saruman.home>
X-Hashcash: 1:20:140822:linux-usb@vger.kernel.org::XKsC2lZXsP9fwws9:0000000000000000000000000000000000000hXw
X-Hashcash: 1:20:140822:balbi@ti.com::nnPHi0XpeKUKabAj:000001M22
X-Hashcash: 1:20:140822:linux-kernel@vger.kernel.org::cg8jUv/yHZ5hVRVs:0000000000000000000000000000000001Vm3
X-Hashcash: 1:20:140822:gregkh@linuxfoundation.org::swNNZGKRMFPH3Y2D:00000000000000000000000000000000000479R
Date: Fri, 22 Aug 2014 17:21:12 +0200
In-Reply-To: <20140822144848.GF22707@saruman.home> (Felipe Balbi's message of
	"Fri, 22 Aug 2014 09:48:48 -0500")
Message-ID: <87a96wsg7r.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

> On Fri, Aug 22, 2014 at 04:44:33PM +0200, Rasmus Villemoes wrote:
>> Clearly this was meant to be an include guard, but a trailing
>> underscore was missing. It has been this way since the file was
>> introduced in 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver").
>> 
>
> right here you need to have:
>
> Fixes: 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver")
> Cc: <stable@vger.kernel.org>

Really? I can't see that it satisfies the
Documentation/stable_kernel_rules.txt. There's no chance of build error, since the
file is only included directly from a single .c file. As you can see on
LKML I've sent a few handfuls of similar patches all over the tree; IMHO
none of them qualify for stable.

If you insist, I'll add the Fixes and Cc tags.

Thanks,
Rasmus
