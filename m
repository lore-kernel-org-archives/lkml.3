Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3FZNyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:54:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59731 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab3FZNyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:54:21 -0400
Date: Wed, 26 Jun 2013 14:54:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/4] arm: Add [U]EFI runtime services support
Message-ID: <20130626135417.GP22026@console-pimps.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6sH4dAVryBp7TeUmrwsJmnMdLsQm++U4EVDJVNi9pnqYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6sH4dAVryBp7TeUmrwsJmnMdLsQm++U4EVDJVNi9pnqYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun, at 02:46:09PM, Grant Likely wrote:
> Eventually we'll need to look at how this interacts with kexec. A
> kexec'd kernel will need to use the mapping already chosen by a
> previous kernel, but that's an issue for another patch series.

FYI, this is exactly what Borislav has been tackling on x86 recently. It
would be nice if we could find one scheme that suits everyone.

-- 
Matt Fleming, Intel Open Source Technology Center
