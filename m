Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbbANK3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:29:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49745 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbANK3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:29:41 -0500
Message-ID: <54B644F3.2000906@ti.com>
Date: Wed, 14 Jan 2015 15:59:07 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: arm: mach-davinci: serial.c:  Cleaning up function
 that are not used anywhere
References: <1417558120-26540-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1417558120-26540-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 03:38 AM, Rickard Strandqvist wrote:
> Remove function serial_read_reg() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Queuing for v3.20 with subject updated to:

"ARM: davinci: serial.c: remove unused serial_read_reg()"

Thanks,
Sekhar
