Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab3IBJC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:02:59 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42334 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab3IBJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:02:56 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1377592285-21148-1-git-send-email-vgupta@synopsys.com>
References: <1377592285-21148-1-git-send-email-vgupta@synopsys.com>
Date: Mon, 2 Sep 2013 12:02:55 +0300
Message-ID: <CAOtvUMcKprmyKdi-+TJNvCNqaDv=6WLxeATkJtFe+b1c1bSSGA@mail.gmail.com>
Subject: Re: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for ARC
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 27, 2013 at 11:31 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
>
> Frame pointer on ARC doesn't serve the conventional purpose of stack
> unwinding due to the typical way ABI designates it's usage.

More out of curiosity to understand the platform better than actual
review - can you explain a little what
you meant by this statement?

Is this statement because of the use of write back mode with ld/st to
or not related?

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
