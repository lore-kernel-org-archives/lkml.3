Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3LLBdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:33:13 -0500
Received: from void.printf.net ([89.145.121.20]:40758 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab3LLBdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:33:11 -0500
From: Chris Ball <cjb@laptop.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci-acpi: add new ACPI ID
References: <1384250493-11232-1-git-send-email-mika.westerberg@linux.intel.com>
	<528205A5.4020105@intel.com>
Date: Wed, 11 Dec 2013 20:33:05 -0500
In-Reply-To: <528205A5.4020105@intel.com> (Adrian Hunter's message of "Tue, 12
	Nov 2013 12:40:37 +0200")
Message-ID: <8738ly7t0u.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 12 2013, Adrian Hunter wrote:
> On 12/11/13 12:01, Mika Westerberg wrote:
>> Newer Intel PCHs with LPSS have the same SDHCI controller than Haswell but
>> ACPI ID is different. Add this ID to the driver list.
>> 
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Thanks, pushed to mmc-next for 3.14.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
