Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaAVC10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:27:26 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45019 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaAVC1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:27:24 -0500
MIME-Version: 1.0
In-Reply-To: <1390348085.5027.18.camel@smoke>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-11-git-send-email-paul.gortmaker@windriver.com> <1390348085.5027.18.camel@smoke>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 21 Jan 2014 21:26:52 -0500
X-Google-Sender-Auth: gRnKHXtjkxbR7iuToVrU7vdFt0I
Message-ID: <CAP=VYLp5UiVJYxtpAcptoqdvgYD_Z=5CMBxmKekXEeSSBgFS9Q@mail.gmail.com>
Subject: Re: [PATCH 10/73] powerpc: use device_initcall for registering rtc devices
To: Geoff Levand <geoff@infradead.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 6:48 PM, Geoff Levand <geoff@infradead.org> wrote:
> Hi Paul,
>
> On Tue, 2014-01-21 at 16:22 -0500, Paul Gortmaker wrote:
>> Currently these two RTC devices are in core platform code
>> where it is not possible for them to be modular.  It will
>> never be modular, so using module_init as an alias for
>> __initcall can be somewhat misleading.
>>
>>  arch/powerpc/kernel/time.c        | 2 +-
>>  arch/powerpc/platforms/ps3/time.c | 3 +--
>>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> I tested the PS3 part of this patch and it seems to work OK.
>
> Acked-by: Geoff Levand <geoff@infradead.org>

Thanks Geoff for the review and testing; I'll add the ack.

Paul.
--

>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
