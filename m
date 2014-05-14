Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaENJDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:03:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35273 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbaENJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:03:49 -0400
Date: Wed, 14 May 2014 10:03:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v2] ARM64: kernel: add compatible cpuinfo
Message-ID: <20140514090325.GB9910@arm.com>
References: <1400036894-16667-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400036894-16667-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 04:08:14AM +0100, Neil Zhang wrote:
> Print the necessary features in order to be backwards compatible with
> ARMv7 and earlier version.

NAK. The compat hwcaps are already advertised in auxv, and I don't have any
plans to align our /proc/cpuinfo format.

Will
