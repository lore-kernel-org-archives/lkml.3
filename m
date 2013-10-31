Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3JaEzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:55:51 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:36354 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3JaEzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:55:48 -0400
MIME-Version: 1.0
In-Reply-To: <87zjpqb08q.fsf@rustcorp.com.au>
References: <20131024084559.GD16735@n2100.arm.linux.org.uk>
	<87mwlyclng.fsf@rustcorp.com.au>
	<CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com>
	<87y55h7vcd.fsf@rustcorp.com.au>
	<CACVXFVPXEUX9JQ2NZvL8=J34zbw2fn202QW2SQtpKjdQ+tv=vg@mail.gmail.com>
	<87sivp7eai.fsf@rustcorp.com.au>
	<CACVXFVN7PiU1dorkeamtC9-Wg_TVQE8xFiJtad-C8q4_=Rc1Ow@mail.gmail.com>
	<874n82gk89.fsf@rustcorp.com.au>
	<20131028132348.62f7e368@tom-ThinkPad-T410>
	<87ob6aeyg4.fsf@rustcorp.com.au>
	<20131030230920.GQ16735@n2100.arm.linux.org.uk>
	<87zjpqb08q.fsf@rustcorp.com.au>
Date: Thu, 31 Oct 2013 12:55:47 +0800
Message-ID: <CACVXFVMp-NWEVEG4-de2QHjUtwHUj+gWXOBjtUZge6_ZrT0UsA@mail.gmail.com>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
From: Ming Lei <tom.leiming@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 11:14 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
>
> Kallsyms tends to fall between modules and scripts.  I assume it's not
> urgent, so no cc:stable on this one.

Rusty, thanks a lot.

BTW, there is already other report on the problem:

   http://lkml.indiana.edu/hypermail/linux/kernel/1310.3/02772.html


Thanks,
-- 
Ming Lei
