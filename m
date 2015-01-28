Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbbA2DVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:21:07 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:64309 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbbA2DVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:21:03 -0500
MIME-Version: 1.0
In-Reply-To: <1422395155-16511-5-git-send-email-james.hogan@imgtec.com>
References: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
	<1422395155-16511-5-git-send-email-james.hogan@imgtec.com>
Date: Wed, 28 Jan 2015 10:48:49 +0000
X-Google-Sender-Auth: M0-J0fZF5O5s8jBucwJxKJ_Z5bA
Message-ID: <CAL1qeaG542xhS9FdEgMPEezaQJpApNTaLE8p-nUbrj9XPVy=xw@mail.gmail.com>
Subject: Re: [PATCH 4/9] irqchip: mips-gic: Fix typo in comment
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
> Fix typo in comment in gic_get_c0_perfcount_int:
> "erformance" -> "performance".
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Andrew Bresticker <abrestic@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: linux-mips@linux-mips.org

Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
