Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaGJSuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:50:54 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:57145 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaGJSux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <53BED94F.9020407@tilera.com>
References: <1404534728-7345-1-git-send-email-xerofoify@gmail.com>
	<53BED94F.9020407@tilera.com>
Date: Thu, 10 Jul 2014 14:50:52 -0400
Message-ID: <CAPDOMVjOh1efYMM4UHv9Ag3o0s02PewAQrbKY3FMBKf9ZGBG7Q@mail.gmail.com>
Subject: Re: [PATCH] tile: Add underscores to defintions
From: Nick Krause <xerofoify@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 2:19 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 7/5/2014 12:32 AM, Nicholas Krause wrote:
>>
>> In file drv_xgbe_impl.h I fixed the definitions for Size Small,
>> Size Large, Size Jumbo to have underscores before and after to
>> follow kernel coding style for internel defentions.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>   arch/tile/include/hv/drv_xgbe_impl.h | 15 +++------------
>
>
> I don't think there is a kernel coding style for internal definitions.
> It's true that double-underscores mean "more raw" in many places, like
> for things like set_bit() vs __set_bit(), but that's not really
> applicable here.  These files are not exported outside of the kernel
> in any case so we don't need any special treatment for them to mark them
> as "internal definitions".
>
> The comment in any case certainly is silly.  It dates back to Jan 2007
> in our internal version control system.  The tilepro hv headers in
> question are largely frozen at this point in our internal "upstream"
> repository where we take these headers from, so it doesn't seem worth
> the effort to try to improve the comments there, nor worth adding skew
> between those headers and the community headers.
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
Chris ,
Would you like me to remove this comment in a patch instead?
Cheers Nick
