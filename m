Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab3DBStS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:49:18 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:54248 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab3DBStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:49:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
	<1364923183-316-4-git-send-email-yinghai@kernel.org>
	<20130402180606.GI29506@redhat.com>
	<CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
Date: Tue, 2 Apr 2013 11:49:13 -0700
X-Google-Sender-Auth: V9mRI3xTKyfYBUPETf2-hKW5TO0
Message-ID: <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 11:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> aka:
> old kexec-tools stay with "crashkernel=X"
> new kexec-tools stay with
> 1. like old kexec tools
> 2. or "crashkernel=X,high" or "crashkernel=X,high crashkernel=Y,low",
> Y could be 100M or 0 etc.

I keep the old logic like:
if there are several "crashkernel=X,high", only last one is honored.
if there are several "crashkernel=Y,low", only last one is honored.

Thanks

Yinghai
