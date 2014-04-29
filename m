Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaD2K3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:29:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55935 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756515AbaD2K3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:29:01 -0400
Date: Tue, 29 Apr 2014 11:28:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 00/10] arm64: UEFI support
Message-ID: <20140429102817.GE17007@arm.com>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 05:09:04PM +0100, Leif Lindholm wrote:
> This set adds support for UEFI to the arm64 port - a stub loader, as
> well as runtime services support for efivars.
> 
> It depends on some core EFI patches currently in linux-next.

The patches look fine to me, they've been through several rounds of
review already. How do we propose these get merged as the series
contains both generic and arm64 patches? And there are dependencies
already in linux-next.

Are the EFI patches in -next pulled from some non-rebaseable branch?

-- 
Catalin
