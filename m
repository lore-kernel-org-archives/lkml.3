Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3KJQoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:44:55 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751531Ab3KJQoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:44:54 -0500
Message-ID: <527FB804.9090509@nod.at>
Date: Sun, 10 Nov 2013 17:44:52 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Shahbaz Youssefi <shabbyx@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Partially Privileged Applications
References: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>	<CAFLxGvx-G8VkBvbdLkYSJee4oAU+4PdHzwszhaTaTMwGJAHkRA@mail.gmail.com> <CALeOzZ-NQyOdxhd3e_c70i0HVMnxS=kcNLTVz8t7UCK9dqUMeg@mail.gmail.com>
In-Reply-To: <CALeOzZ-NQyOdxhd3e_c70i0HVMnxS=kcNLTVz8t7UCK9dqUMeg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.11.2013 17:24, schrieb Shahbaz Youssefi:
> Not sure if I understood you (or you understood me). We don't throw
> away anything. Only difference would be instead of generating a trap
> to call a function in the kernel, we can just call it and have the
> hardware take care of privileges. The "trap way" is the one that
> actually seems hacky! A hack proposed to fix the brain-dead processors
> of twenty years ago.
> 
> As a bonus you would also have more control over what parts of a
> driver actually get run in privileged mode.
> 
> Care to explain why you would call this a step backwards?

Maybe I did not understand your idea. But to me it sounds like plain old call gates.
See: http://en.wikipedia.org/wiki/Call_gate

Thanks,
//richard
