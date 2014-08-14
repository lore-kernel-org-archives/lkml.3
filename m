Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaHNMwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:52:13 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41553 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752368AbaHNMwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:52:12 -0400
Date: Thu, 14 Aug 2014 13:51:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Use 'model' property to set machine_name from
 Device Tree
Message-ID: <20140814125143.GC9039@arm.com>
References: <1404697991-32191-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404697991-32191-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 02:53:11AM +0100, Chanwoo Choi wrote:
> This patch use 'model' property from Device Tree to set machine_name.
> The arm64 has already got the machine_name from Device Tree.

FWIW, we removed this entirely from arm64 (see commit d7a49086f2 "arm64:
cpuinfo: print info for all CPUs").

-- 
Catalin
