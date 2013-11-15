Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3KOSEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 13:04:30 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51009 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3KOSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 13:04:23 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
Date: Fri, 15 Nov 2013 10:04:22 -0800
Message-ID: <CAOesGMh+2Qs_cVMtdkpyXR44NJkQscs0eP_=pxwKXHkopaAKog@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] arm: [U]EFI runtime services support
From: Olof Johansson <olof@lixom.net>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, roy.franz@linaro.org,
        msalter@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 3, 2013 at 4:24 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> In systems based on [U]EFI-conformant firmware, runtime services provide
> a standardised way for the kernel to update firmware environment
> variables. This is used for example by efibootmgr to update which image
> should be loaded on next boot.
>
> This patchset implements basic support for UEFI runtime services on ARM
> platforms, as well as the basic underlying EFI support. It also defines
> a mechanism by which the required information is passed from the
> bootloader to the kernel via FDT entries.
>
> This patchset depends on the previously submitted early_ioremap() and
> generic UEFI config table scanning patchsets.
>
> Changes from v1:
> - Updated FDT bindings, based on feedback.
> - Use common config table scanning and address lookup code.
> - Add dependency on !CPU_BIG_ENDIAN (for now).
> - Add proper efi_enabled() facility.
> - Documentation updates.

This series is generally looking sane to me without looking at the
code in very close detail.

Do you have a test setup that you've been using for this that you
could give a pointer to?


-Olof
