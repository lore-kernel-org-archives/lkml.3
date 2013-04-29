Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3D2DSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 23:18:24 -0400
Received: from ozlabs.org ([203.10.76.45]:52311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3D2DSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 23:18:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        anup.patel@linaro.org,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: Re: [PATCH 1/2] virtio: console: Add early writeonly register to config space
In-Reply-To: <1366974299-17877-2-git-send-email-pranavkumar@linaro.org>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <1366974299-17877-2-git-send-email-pranavkumar@linaro.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 29 Apr 2013 12:40:23 +0930
Message-ID: <87mwsic9r4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
> This patch adds a early_wr register (writeonly) in config space of virtio console device which can be used for debugging.
>
> The patch also updates virtio-spec in Documentation to reflect this feature addition in virtio console.

Perhaps change the name to VIRTIO_CONSOLE_F_EMERGENCY_WRITE.  But let's
resolve the qemu discussion first...

Cheers,
Rusty.
