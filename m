Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbbA1Uh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:37:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44785 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbbA1Uhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:37:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAOZdJXU2bFR1T4ZnGavvnrUXAp5e=vNt9g6WKX46H8qs1wz-TQ@mail.gmail.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
	<1421247905-3749-5-git-send-email-hanjun.guo@linaro.org>
	<CAOZdJXU2bFR1T4ZnGavvnrUXAp5e=vNt9g6WKX46H8qs1wz-TQ@mail.gmail.com>
Date: Wed, 28 Jan 2015 12:08:24 -0600
Message-ID: <CAOZdJXXe+29rux1L3QYBX0yHLy3kdi+ZJrXVd=XfgYN=R6DtKA@mail.gmail.com>
Subject: Re: [Linaro-acpi] [PATCH v7 04/17] ARM64 / ACPI: Introduce
 early_param for "acpi" and pass acpi=force to enable ACPI
From: Timur Tabi <timur@codeaurora.org>
To: Timur Tabi <timur@codeaurora.org>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        wangyijing@huawei.com, Rob Herring <robh@kernel.org>,
        linux-acpi@vger.kernel.org, phoenix.liyi@huawei.com,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:58 AM, Timur Tabi <timur@codeaurora.org> wrote:
> What is the reason to assume that DT is preferred over ACPI?  I would
> have thought that if ACPI is present, then it means we're on an ARM64
> server platform, and therefore it should be used.  It seems silly to
> require acpi=force on every ARM64 server platform.

So it looks like there's a whole conversation about this already in
this thread that I didn't notice.  However, reading through all of it,
I still don't understand sure why the presence of ACPI tables is
insufficient to enable ACPI.  In what situation would we want to
ignore ACPI tables that are present?

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
