Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3LET1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:27:25 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:42028 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3LET1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:27:24 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
To: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        patches@linaro.org, Roy Franz <roy.franz@linaro.org>
In-Reply-To: <1385595115-21488-3-git-send-email-roy.franz@linaro.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org> < 1385595115-21488-3-git-send-email-roy.franz@linaro.org>
Date: Thu, 05 Dec 2013 19:27:19 +0000
Message-Id: <20131205192719.71C6AC40785@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 15:31:51 -0800, Roy Franz <roy.franz@linaro.org> wrote:
> Both ARM and ARM64 stubs will update the device tree
> that they pass to the kernel.  In both cases they
> primarily need to add the same UEFI related information,
> so the function can be shared.
> Create a new FDT related file for this to avoid use
> of architecture #ifdefs in efi-stub-helper.c
> Change EFI allocation type for memory map to
> EFI_RUNTIME_SERVICES_DATA, since we are passing
> this buffer to the kernel, or immediately freeing it.

Nit: You're using a very short line length for the commit block. 72
columns is more customary.

g.

