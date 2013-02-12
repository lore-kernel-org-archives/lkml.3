Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab3BLLE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:04:59 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:43721 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758296Ab3BLLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:04:58 -0500
Date: Tue, 12 Feb 2013 11:03:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Len Brown <lenb@kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/16] ARM64 idle: delete pm_idle
Message-ID: <20130212110328.GB14899@arm.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
 <c09e2c0f2928cfe6173bcafe0d906bf87287d5c2.1360475150.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c09e2c0f2928cfe6173bcafe0d906bf87287d5c2.1360475150.git.len.brown@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 05:58:14AM +0000, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> pm_idle() on arm64 was a synonym for default_idle(),
> so remove it and invoke default_idle() directly.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: linux-arm-kernel@lists.infradead.org

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
