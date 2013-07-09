Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3GIRHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:07:47 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42040 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3GIRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <51DC4075.1000708@stranner.org>
References: <1373023979-20537-1-git-send-email-artagnon@gmail.com>
	<1373151605.27613.9@driftwood>
	<478d866c-606e-42de-9779-6ae18d70e7f1@CO1EHSMHS014.ehs.local>
	<51DC4075.1000708@stranner.org>
Date: Tue, 9 Jul 2013 10:07:44 -0700
Message-ID: <CAKbGBLgrTtMfkg9VEiQ=5JPzJvCUa5bPUjPHVswZFxviY1BKdg@mail.gmail.com>
Subject: Re: [PATCH] menuconfig: Allow j/k to move down/up the menu
From: Steven Noonan <steven@uplinklabs.net>
To: Heimo Stranner <heimo@stranner.org>
Cc: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        artagnon@gmail.com,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 9:55 AM, Heimo Stranner <heimo@stranner.org> wrote:
>
>> Well, one advantage of these key bindings is, that you don't have to
>> move your hands away from the base line. And as vim user I find myself
>> using vim key sequences in all tools. I cannot even count how many
>> processes I accidentally killed because I tried to scroll using 'k' in
>> htop where it does 'kill'.
>>
>> In a nutshell: I'm all for vim key bindings everywhere!
>>
> I can't agree more!
>
> Because vim key bindings are rather common I can't see a problem if this
> patch is applied.

The biggest problem I see is the conflict between j/k and the letter
shortcuts used to jump to specific menu items (the letter highlighted
in blue on each item). But I haven't ever used that functionality in
practice, so who knows.
