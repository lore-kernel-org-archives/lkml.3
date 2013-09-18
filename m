Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3IRGOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:14:35 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:38558 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3IRGNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:35 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 21/28] of: remove early_init_dt_setup_initrd_arch
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
In-Reply-To: <1379372965-22359-22-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-22-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 22:39:00 -0500
Message-Id: <20130918033900.D66BCC42CAF@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 18:09:17 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> All arches do essentially the same thing now for
> early_init_dt_setup_initrd_arch, so it can now be removed.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Grant Likely <grant.likely@linaro.org>
