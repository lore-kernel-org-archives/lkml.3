Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaGJJYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:24:06 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55747 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751984AbaGJJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:24:04 -0400
Date: Thu, 10 Jul 2014 10:23:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v8 0/2] context tracker support for arm64
Message-ID: <20140710092349.GG16137@arm.com>
References: <1401830991-21233-1-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401830991-21233-1-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:29:49PM +0100, Larry Bassel wrote:
> Implement and enable context tracking for arm64 (which is
> a prerequisite for FULL_NOHZ support). This patchset
> builds upon earlier work by Kevin Hilman and is based on
> Will Deacon's tree.

Both patches applied (via Will) for 3.17. Thanks.

-- 
Catalin
