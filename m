Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3GIRQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:16:03 -0400
Received: from stranner.org ([5.135.166.179]:43105 "EHLO stranner.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab3GIRP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:15:58 -0400
Message-ID: <51DC4541.8010409@stranner.org>
Date: Tue, 09 Jul 2013 19:15:45 +0200
From: Heimo Stranner <heimo@stranner.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: linux-kernel@vger.kernel.org
References: <1373023979-20537-1-git-send-email-artagnon@gmail.com> <1373151605.27613.9@driftwood> <478d866c-606e-42de-9779-6ae18d70e7f1@CO1EHSMHS014.ehs.local> <51DC4075.1000708@stranner.org> <CAKbGBLgrTtMfkg9VEiQ=5JPzJvCUa5bPUjPHVswZFxviY1BKdg@mail.gmail.com>
In-Reply-To: <CAKbGBLgrTtMfkg9VEiQ=5JPzJvCUa5bPUjPHVswZFxviY1BKdg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 178.190.210.148
X-SA-Exim-Mail-From: heimo@stranner.org
Subject: Re: [PATCH] menuconfig: Allow j/k to move down/up the menu
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on stranner.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-07-09 19:07, Steven Noonan wrote:
> On Tue, Jul 9, 2013 at 9:55 AM, Heimo Stranner <heimo@stranner.org> wrote:
>>> Well, one advantage of these key bindings is, that you don't have to
>>> move your hands away from the base line. And as vim user I find myself
>>> using vim key sequences in all tools. I cannot even count how many
>>> processes I accidentally killed because I tried to scroll using 'k' in
>>> htop where it does 'kill'.
>>>
>>> In a nutshell: I'm all for vim key bindings everywhere!
>>>
>> I can't agree more!
>>
>> Because vim key bindings are rather common I can't see a problem if this
>> patch is applied.
> The biggest problem I see is the conflict between j/k and the letter
> shortcuts used to jump to specific menu items (the letter highlighted
> in blue on each item). But I haven't ever used that functionality in
> practice, so who knows.
I haven't thought about that. Obviously you are right, "Kernel hacking"
and "Kernel compression mode" just being two examples that use k which I
found in a very quick search.
