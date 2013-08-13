Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3HMN5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab3HMN46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:56:58 -0400
Message-ID: <1376402189.27484.13.camel@t520.redhat.com>
Subject: Re: [PATCH 02/16] Add system pointer argument to shared EFI stub
 related functions so they no longer use global system table pointer as they
 did when part of eboot.c. This code is now shared, so using a global
 variable as part of the interface is not that nice. Also, by avoiding any
 global variables in the ARM EFI stub, this allows the code to be position
 independent without requiring GOT fixups.
From: Mark Salter <msalter@redhat.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Date: Tue, 13 Aug 2013 09:56:29 -0400
In-Reply-To: <1376090777-20090-3-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-3-git-send-email-roy.franz@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   38 +++++++------
>  drivers/firmware/efi/efi-stub-helper.c |   96 +++++++++++++++++---------------
>  2 files changed, 72 insertions(+), 62 deletions(-)

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>


