Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaBROY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:24:56 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38051 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaBROYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:24:55 -0500
MIME-Version: 1.0
In-Reply-To: <87zjlpcecu.fsf@redhat.com>
References: <87zjlpcecu.fsf@redhat.com>
Date: Tue, 18 Feb 2014 09:24:54 -0500
X-Google-Sender-Auth: Qt5qh8uaooptKOnBsntzm19UB2Q
Message-ID: <CA+5PVA6v=r5_qR30_2mRFWsT3kuOcLj900DQ7TwxCfBva2mWig@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 0 at lib/dma-debug.c:491
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Madper Xie <cxie@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:02 PM, Madper Xie <cxie@redhat.com> wrote:
> Howdy all,
>   Meet following warning and call trace:
>
> [307001.720980] ------------[ cut here ]------------
> [307001.720994] WARNING: CPU: 0 PID: 0 at lib/dma-debug.c:491 add_dma_entry+0x127/0x130()
> [307001.720996] DMA-API: exceeded 7 overlapping mappings of pfn 1932f8

This should be fixed by this patch:

http://marc.info/?l=linux-kernel&m=139233546223338&w=2

josh
