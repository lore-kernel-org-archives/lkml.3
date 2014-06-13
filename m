Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaFMBwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 21:52:39 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:62638 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaFMBwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 21:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <539A58AD.4030404@zytor.com>
References: <cover.1402620737.git.luto@amacapital.net> <d10618176c4bd39b457a5e85c497295c90cab1bc.1402620737.git.luto@amacapital.net>
 <539A58AD.4030404@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 18:52:17 -0700
Message-ID: <CALCETrXttYofO89Y40mYC2xXjZxuJbenAUNY+2w=vT5nr3F7VA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] x86,vdso: Hack to keep 64-bit Go programs working
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kui Zhang <kuizhang@gmail.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 6:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2014 05:53 PM, Andy Lutomirski wrote:
>>
>> This is currently broken for big-endian build hosts.  The hack
>> should also be disabled for x32, but I'm not sure what the right way
>> to do that is.
>>
>
> This comment is obsolete, no?

Yes, it's obsolete.  Whoops.

Want a new patch?

--Andy
