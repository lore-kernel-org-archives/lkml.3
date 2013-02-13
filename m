Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab3BMMz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:55:58 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45978 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3BMMz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:55:56 -0500
Message-ID: <1360760152.24917.33.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: linux-next: manual merge of the ia64 tree with Linus' tree
From: Matt Fleming <matt.fleming@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Wed, 13 Feb 2013 12:55:52 +0000
In-Reply-To: <20130213130559.dd6b2ac2c59093cc1794f41b@canb.auug.org.au>
References: <20130213130559.dd6b2ac2c59093cc1794f41b@canb.auug.org.au>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 13:05 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the ia64 tree got a conflict in
> drivers/firmware/efivars.c between commit 83e68189745a ("efi: Make
> 'efi_enabled' a function to query EFI facilities") from the  tree and
> commit a93bc0c6e07e ("efi_pstore: Introducing workqueue updating sysfs")
> from the ia64 tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen, this is all correct.

