Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3KUXKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:10:31 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:55675 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3KUXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:10:30 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/17] Convert ARM sched_clock users to sched_clock_register()
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 21 Nov 2013 15:10:27 -0800
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Fri, 15 Nov 2013 15:26:08 -0800")
Message-ID: <87li0h8i70.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Boyd <sboyd@codeaurora.org> writes:

> Olof,
>
> Please consider picking up these simple conversion patches. They
> were sent a few months back[1] but I didn't keep pushing them due
> to the complex path to mainline that the core patches took. I've
> picked up the acks and resent. Now that the core kernel changes have
> landed in Linus' tree it's much easier to pull these changes in.

Just to clarify, are the dependencies in v3.12? or were they merged for
the v3.13 merge window and just recently it Linus' tree.

Kevin
