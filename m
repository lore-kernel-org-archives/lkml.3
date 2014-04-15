Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaDODp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:45:28 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48659 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaDODp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:45:26 -0400
MIME-Version: 1.0
In-Reply-To: <534C3929.8060501@codeaurora.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
	<25b069afdaa6f28e561caefa74cd62c62974099a.1397492345.git.viresh.kumar@linaro.org>
	<534C3929.8060501@codeaurora.org>
Date: Tue, 15 Apr 2014 09:15:26 +0530
Message-ID: <CAKohpo=Y5J-H0L8iiAksdCvs-1fEyi+3TrA7Y17mTXhTJZimXQ@mail.gmail.com>
Subject: Re: [PATCH 18/38] tick-common: don't set mode to CLOCK_EVT_MODE_UNUSED
 in tick_shutdown()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 01:08, Stephen Boyd <sboyd@codeaurora.org> wrote:
> But see the comment above this assignment. The point is to avoid calling
> the ->set_mode function.

Okay, that was a stupid change :)
