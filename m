Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab3KSHwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:52:15 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64949 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3KSHwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:52:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131119124357.a6191743b0f568d40c8291d5@canb.auug.org.au>
References: <20131119124357.a6191743b0f568d40c8291d5@canb.auug.org.au>
Date: Tue, 19 Nov 2013 08:52:13 +0100
Message-ID: <CACRpkdbSrWK2iaajYd7c-5sRXk+Cv2+s2TLbt4N8LzVKSKamNg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the gpio tree with the pm tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 2:43 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the gpio tree got a conflict in
> drivers/gpio/gpiolib.c between commit 7b1998116bbb ("ACPI / driver core:
> Store an ACPI device pointer in struct acpi_dev_node") from the pm tree
> and commit f760f1967ee8 ("gpiolib: use dedicated flags for GPIO
> properties") from the gpio tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Oh I never saw that patch before ... anyway it seems to be
correct, thanks.

Yours,
Linus Walleij
