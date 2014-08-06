Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaHFOzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:55:08 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51225 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaHFOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:55:06 -0400
Date: Wed, 6 Aug 2014 15:55:03 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140806145503.GF15082@console-pimps.org>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
 <20140806132941.GJ4179@bivouac.eciton.net>
 <20140806140155.GC15082@console-pimps.org>
 <CAKv+Gu8ey1iKu-_wS6yYaEXQaQMDXa+PF5Kiw+edA9a_OE1EAw@mail.gmail.com>
 <20140806141814.GD15082@console-pimps.org>
 <20140806144839.GK4179@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806144839.GK4179@bivouac.eciton.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug, at 03:48:39PM, Leif Lindholm wrote:
> 
> Since we're now overlaying two different meanings onto the
> EFI_RUNTIME_SERVICES bit, could we add comments at set/clear points to
> explicitly state the intended action? I.e.:
> 
> /* Set to attempt runtime services initialisation */
> 
> /* Clear to indicate runtime services will not be available */

Good idea.

My patch was only a hack to show how it's possible to use efi_enabled().
It may require some finessing ;-)

-- 
Matt Fleming, Intel Open Source Technology Center
