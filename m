Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3LEP7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:59:42 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30396 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752892Ab3LEP7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:59:41 -0500
Date: Thu, 5 Dec 2013 15:59:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Subject: Re: [PATCH 3/3] arm64: add EFI runtime services
Message-ID: <20131205155934.GA1495@darko.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-4-git-send-email-msalter@redhat.com>
 <20131205152510.GB974@darko.cambridge.arm.com>
 <1386258761.1861.137.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386258761.1861.137.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 03:52:41PM +0000, Mark Salter wrote:
> On Thu, 2013-12-05 at 15:25 +0000, Catalin Marinas wrote:
> > I lost track of the early_ioremap status for arm/arm64? Was there more
> > progress since October (I think)?
> 
> See the two patch series:
> 
>  https://lkml.org/lkml/2013/11/25/474
> 
> and
> 
>  https://lkml.org/lkml/2013/11/27/621
> 
> The latter early_ioremap depends on the first although there are no
> arm64 bits in the first. All of the arm64 early_ioremap stuff is in
> the latter.

Thanks. I was even cc'ed but too many emails in my inbox ;). I'll have a
look.

-- 
Catalin
