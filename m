Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaGWPpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:45:17 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35272 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaGWPpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:45:15 -0400
MIME-Version: 1.0
In-Reply-To: <8738dsi7l7.fsf@nemi.mork.no>
References: <1406053161-5048-1-git-send-email-xerofoify@gmail.com>
	<8738dsi7l7.fsf@nemi.mork.no>
Date: Wed, 23 Jul 2014 11:45:13 -0400
Message-ID: <CAPDOMVjwzfmHAKGBENfpxN2cswckq2T=QbQa56k3w0X+cDuJKg@mail.gmail.com>
Subject: Re: [PATCH] drbd: Remove fix me statements
From: Nick Krause <xerofoify@gmail.com>
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 8:27 AM, Bjørn Mork <bjorn@mork.no> wrote:
> Nicholas Krause <xerofoify@gmail.com> writes:
>
>> This removes no longer needed fix me statements
>
> If you claim that they no longer are needed then I expect you to explain
> what's changed since they were added.
>
>> as the spinlocks
>> are needed to protect against other users of the list accessing
>>  it when items on it are being moved off it.
>
> Yes, that's most likely why the locking is there.
>
> The FIXMEs on the other hand, are probably there to tell you that it
> would be nice to get rid of the double locking.  I don't see that
> changing.
>
>
> Bjørn
>

Bjorn,
Can we remove the double locking  as you are stating or do  we still need it
to protect against the list being accessed  as the list seems to be moving
to a spinlock protected list.
Cheers Nick
