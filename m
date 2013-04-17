Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3DQAbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:31:04 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60894 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3DQAbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:31:02 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:398b:f520:9afe:94ff:fe3f:c618]
In-Reply-To: <1366148520-29954-1-git-send-email-matt@console-pimps.org>
References: <1366148520-29954-1-git-send-email-matt@console-pimps.org>
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 17 Apr 2013 02:30:40 +0200
Message-ID: <CAG-2HqVBiSMp648F=zdUBDWQ49_a=rEPJ_TH__zWtaPSjju-KQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Chainsaw efivars.c
To: Matt Fleming <matt@console-pimps.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Tue, Apr 16, 2013 at 11:41 PM, Matt Fleming <matt@console-pimps.org> wrote:
> This patch series introduces the new efivar_entry API, and splits out the major
> parts of efivars.c into new files. In particular, having the efivarfs code
> under fs/ allows building an efivarfs.ko module, which means mount(8) can
> automatically load it.
>
> The remaining EFI code is repositioned under drivers/firmware/efi/.

These all look good to me, so feel free to add my Reviewed-by.

Tested on top of 3.9-rc7, with everything built as modules. Everything
works as intended: systemd correctly detects it is on an EFI system,
so mounts efivarfs, which auto-loads the required modules.

Thanks a lot!

Tom
