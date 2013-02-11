Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3BKMEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:04:06 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37125 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab3BKMEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:04:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the pm tree
Date: Mon, 11 Feb 2013 13:10:29 +0100
Message-ID: <2288610.IGA9461Y6F@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130211154255.62c1326a5f4a52b4cc057713@canb.auug.org.au>
References: <20130211154255.62c1326a5f4a52b4cc057713@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 03:42:55 PM Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/acpi/Kconfig between commit cb2b212bc7ff ("ACPI / scan: Make
> container driver use struct acpi_scan_handler") from the pm tree and
> commit f756f28b84af ("drivers/acpi: remove depends on CONFIG_EXPERIMENTAL")
> from the driver-core tree.
> 
> I fixed it up and can carry the fix as necessary (no action is required).

Thanks for the notice and for fixing this!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
