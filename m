Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3A2RzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:55:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:60979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab3A2Ry7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:54:59 -0500
Message-ID: <1359482093.8282.94.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86, efi: remove attribute check from setup_efi_pci
From: Matt Fleming <matt.fleming@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        x86@kernel.org
Date: Tue, 29 Jan 2013 17:54:53 +0000
In-Reply-To: <5107FE48.7080402@canonical.com>
References: <5107FE48.7080402@canonical.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 17:52 +0100, Maarten Lankhorst wrote:
> It looks like the original commit that copied the rom contents from efi always copied
> the rom, and the fixup in setup_efi_pci from commit 886d751a2ea99a160
> ("x86, efi: correct precedence of operators in setup_efi_pci") broke that.
> 
> This resulted in macbook pro's no longer finding the rom images, and thus not being able to use the radeon card any more.
> 
> The solution is to just remove the check for now, and always copy the rom if available.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Applied, thanks!

