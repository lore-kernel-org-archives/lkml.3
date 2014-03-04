Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaCDKXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:23:34 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50249 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756721AbaCDKXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:23:33 -0500
Date: Tue, 4 Mar 2014 10:23:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Graeme Gregory <graeme.gregory@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
Message-ID: <20140304102316.GG30596@arm.com>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 02:15:45AM +0000, Graeme Gregory wrote:
> +ACPI ARM64

That's a pretty broad statement for a single file. Is it core support,
architected peripherals, SoC?

> +M:	Hanjun Guo <hanjun.guo@linaro.org>
> +M:	Graeme Gregory <graeme.gregory@linaro.org>
> +S:	Supported
> +L:	linux-acpi@vger.kernel.org
> +F:	drivers/acpi/plat/arm-core.c

This patch should be part of the series introducing the arm-core.c file
and it will be ACKed (or NAKed) following review. We can't really commit
maintainers to a file which does not exist in mainline and while there is
still feedback to be addressed. It's like a blank cheque.

-- 
Catalin
