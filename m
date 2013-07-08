Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3GHTCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:02:32 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:51279 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3GHTCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:02:30 -0400
MIME-Version: 1.0
In-Reply-To: <51DB069C.1010607@zytor.com>
References: <20130626122331.GK22026@console-pimps.org>
	<20130703081903.GI25291@console-pimps.org>
	<3908561D78D1C84285E8C5FCA982C28F31C76880@ORSMSX106.amr.corp.intel.com>
	<51DB069C.1010607@zytor.com>
Date: Mon, 8 Jul 2013 12:02:29 -0700
Message-ID: <CA+8MBbLW3e96DO6mGdQ5VkzMUs-auQdCOkXv_DDiyB1t61buBA@mail.gmail.com>
Subject: Re: [GIT PULL] EFI changes for v3.11
From: Tony Luck <tony.luck@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 11:36 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I had hoped to have this patch follow in the same path that the
>> one that changed the types and introduced the warnings took ...
>> but since that didn't work perhaps I should just ask Linus to pull
>> it from my ia64 tree.
>>
>
> I can push it, although it seems a bit odd to me to push an ia64-only
> patch through the x86 tree.
>
> Let me know what you prefer.

I've sent Linus a "please pull" for this from my ia64 tree.

-Tony
