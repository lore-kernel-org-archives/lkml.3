Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3CYJpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:45:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34048 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3CYJpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <51501BB6.5000306@cn.fujitsu.com>
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
	<514FBD6E.2030706@cn.fujitsu.com>
	<CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com>
	<514FC385.4030008@cn.fujitsu.com>
	<CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com>
	<514FDE5F.5020500@cn.fujitsu.com>
	<CAAO_Xo6dG8C_-e4mHuKm12vQ7MVoYR8fPggK00T28i0JzqpDyA@mail.gmail.com>
	<514FF70A.6080402@cn.fujitsu.com>
	<CAAO_Xo5bbABJOPrC43GtKw3m=bUtqzALoHSHz=f_Dj0QFobqgg@mail.gmail.com>
	<CAAO_Xo7CTzow1TN+4bmmHH9KB4NSLRv5ZsOmwEC2KGTxDc-1Ug@mail.gmail.com>
	<51501BB6.5000306@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 17:45:53 +0800
Message-ID: <CAAO_Xo5=EcXUtWapCiacdsp1184mUQkpPqfQ27tAjr223w0Q4w@mail.gmail.com>
Subject: Re: Question: How to distribute the interrupts over multiple cores?
From: Lenky Gao <lenky.gao@gmail.com>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry I can't find physflat_cpu_mask_to_apicid() in latest Linux tree, seems it has
> been removed out.. But just consider what you said that it's limited by "8 cores"
> IMHO it's impossible or it is a bug.

Here:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/arch/x86/kernel/apic/apic_flat_64.c?id=v2.6.30.8#n281



-- 
Regards,

Lenky
