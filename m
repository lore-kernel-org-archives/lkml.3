Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3BVArp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 19:47:45 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:42559 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3BVAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 19:47:44 -0500
MIME-Version: 1.0
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
Date: Thu, 21 Feb 2013 16:47:41 -0800
X-Google-Sender-Auth: l0XniQ8zHEOoqGGBR_4XpsmDxf4
Message-ID: <CA+55aFwjvH=rGb6Qif5Ty17EmVXiLoeUSMTWy8LzOphQUrd6Sg@mail.gmail.com>
Subject: Re: [GIT PULL 00/09] arm-soc: changes for 3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ARM SoC <arm@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 1:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> The merge conflicts I mention in the tags are all for conflicts
> between the arm-soc branches. There are a few more conflicts
> with other stuff you already pulled, but it all looks simple
> as well. I have uploaded a 'for-linus' branch to the arm-soc
> tree with the resolutions I used.

You also had some extra stuff in that branch, but apart from that, I
think our resolutions are identical except for trivial include file
ordering and whitespace.

But you should check, since I don't cross-compile the arm stuff..

              Linus
