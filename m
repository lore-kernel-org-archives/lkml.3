Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaHTTbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:31:06 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64046 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaHTTbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:31:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v3] arm/smp: Absorb boot_secondary()
Date: Wed, 20 Aug 2014 21:30:28 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1404918119-3676-1-git-send-email-geert+renesas@glider.be> <CAMuHMdXp0ruZjjJLXmWyCdfAXs9_9xFHDcmJ08M9_SbZqqq04g@mail.gmail.com>
In-Reply-To: <CAMuHMdXp0ruZjjJLXmWyCdfAXs9_9xFHDcmJ08M9_SbZqqq04g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201408202130.28389.arnd@arndb.de>
X-Provags-ID: V02:K0:3tiCFG5/dyuQyTUNc8NqBEoS0LH+sBJHjn/Qs43mDhc
 4wyUZtHT9DBnmXiU33ZdGd0iyv8m5ZnccwAphfhT+bwAx2Wf+/
 Q90hnFv8A2/z7FMV1onxzblZMPV8ci9RFM8E/Z/dpIqhd+/VhO
 DMl1mBJ/Qd2DP6H4LwaxA7mfahmzOfYKuMajUpDg5V9MxABk1l
 PRvK6gPbt77InL/PFdvT8G3kpjpmn2GVnI0hut3n8Pq+87qfZE
 jxI8hLLXACMk3sQ9gzgwGKYOqqR/or9zpJZHcHXlmDi5QSVQvB
 B5e7zlf5ShKj46T1sJxBqYkBp1VGx3nfLgnwPhtyJy/6FgZiYi
 YhbJTcEH6mmjeLjxHFwmfAL5r2OqiwsyaPaBJ1578
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2014, Geert Uytterhoeven wrote:
> 
> Ping?
> 
> On Wed, Jul 9, 2014 at 5:01 PM, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > After becoming a mandatory function, boot_secondary() is no longer used
> > outside arch/arm/kernel/smp.c. Hence remove its public prototype, and,
> > as suggested by Arnd, let it be absorbed by its single caller.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>

I think you should add the patch to Russell's patch tracking system
at http://www.arm.linux.org.uk/developer/patches to get it applied.

	Arnd
