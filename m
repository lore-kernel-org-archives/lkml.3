Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763714AbbA2DKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:10:16 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:55101 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbA2DKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:10:09 -0500
MIME-Version: 1.0
In-Reply-To: <1422395155-16511-6-git-send-email-james.hogan@imgtec.com>
References: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
	<1422395155-16511-6-git-send-email-james.hogan@imgtec.com>
Date: Wed, 28 Jan 2015 10:49:44 +0000
X-Google-Sender-Auth: fEY3NbjH2oZfAks9fQXIMkwrrIE
Message-ID: <CAL1qeaH60ERCFBNEch2htj37opy9P6V0Pzyn87tTT-YtUOis1g@mail.gmail.com>
Subject: Re: [PATCH 5/9] irqchip: mips-gic: Add missing definitions for FDC IRQ
From: Andrew Bresticker <abrestic@chromium.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 9:45 PM, James Hogan <james.hogan@imgtec.com> wrote:
> Add missing VPE_PEND, VPE_RMASK and VPE_SMASK definitions for the local
> FDC interrupt.
>
> These local interrupt definitions aren't directly used, but if they
> exist they should be complete.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Andrew Bresticker <abrestic@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: linux-mips@linux-mips.org

Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
