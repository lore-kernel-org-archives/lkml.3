Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3LEMEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:04:07 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60707 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab3LEMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:04:05 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 0/3] (U)EFI runtime services for arm
To: Leif Lindholm <leif.lindholm@linaro.org>,
        Matt Fleming <matt@console-pimps.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        matt.fleming@intel.com, roy.franz@linaro.org, msalter@redhat.com,
        patches@linaro.org, linaro-uefi@lists.linaro.org, mark.rutland@arm.com
In-Reply-To: <20131129175850.GW24997@rocoto.smurfnet.nu>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> < 20131129115319.GC11775@console-pimps.org> <20131129175850.GW24997@rocoto. smurfnet.nu>
Date: Thu, 05 Dec 2013 12:04:00 +0000
Message-Id: <20131205120400.45EC9C407BC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013 18:58:51 +0100, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Fri, Nov 29, 2013 at 11:53:19AM +0000, Matt Fleming wrote:
> > On Thu, 28 Nov, at 04:41:20PM, Leif Lindholm wrote:
> > > In systems based on [U]EFI-conformant firmware, runtime services provide
> > > a standardised way for the kernel to update firmware environment
> > > variables. This is used for example by efibootmgr to update which image
> > > should be loaded on next boot.
> > > 
> > > This patchset implements basic support for UEFI runtime services on ARM
> > > platforms, as well as the basic underlying EFI support. It also defines
> > > a mechanism by which the required information is passed from the
> > > bootloader (the EFI stub submitted separately) to the kernel via FDT
> > > entries.
> > 
> > This all looks pretty good to me. Is this series going through the ARM
> > trees?
> 
> Thanks.
> That's the plan.

FWIW, I would like to see this merged this cycle. I think it is ready
enough and can be fixed up in-place.

g.

