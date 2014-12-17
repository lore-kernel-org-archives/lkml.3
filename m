Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaLQIKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:10:01 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42237 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaLQIJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:09:59 -0500
From: Julian Brost <julian@0x4a42.net>
X-Google-Original-From: Julian Brost <linux-kernel@0x4a42.net>
Message-ID: <54913A52.2000305@0x4a42.net>
Date: Wed, 17 Dec 2014 09:09:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@i4.cs.fau.de
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Fabian Hofmann <fabian.hofmann@fau.de>
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix coding style
References: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
In-Reply-To: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.12.2014 18:30, Julian Brost wrote:
> Removed use of the deprecated DEFINE_PCI_DEVICE_TABLE macro, replaced a call to
> kzalloc with kcalloc, fixed whitespace alignment in macros and some other minor
> checkpatch warnings.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
> Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>

Sorry about that mail, it was actually intended to be sent to an
internal mailing list only, so please ignore it. I'll send a proper
version of the patch later. Thanks.
