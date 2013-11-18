Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3KRKvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:51:10 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51466 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3KRKvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:51:05 -0500
MIME-Version: 1.0
In-Reply-To: <1384249952-10085-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1384249952-10085-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 18 Nov 2013 11:51:04 +0100
Message-ID: <CACRpkdabUuvZaTYN5r8iacW6Tm5WnQwBX7JUtv7dEuE=3_QO5w@mail.gmail.com>
Subject: Re: [PATCH] gpio/lynxpoint: add new ACPI ID
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:52 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Newer Intel PCHs have the same GPIO controller than Haswell but the ACPI ID
> is different. Add this ID to the driver supported IDs list.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied (for v3.14).

Yours,
Linus Walleij
