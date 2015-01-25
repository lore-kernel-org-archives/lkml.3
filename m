Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbbAYJbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 04:31:09 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47702 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbbAYJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 04:30:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+-g7v670Bk5V3CKTYgjkKwgFVfKYy2ktyZ5LTGtsSvzw@mail.gmail.com>
References: <1421150406-20255-1-git-send-email-johan@kernel.org>
 <1421150406-20255-3-git-send-email-johan@kernel.org> <CAAVeFu+-g7v670Bk5V3CKTYgjkKwgFVfKYy2ktyZ5LTGtsSvzw@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 25 Jan 2015 18:30:27 +0900
Message-ID: <CAAVeFuJMFn95=SK7XNyOKwmmMqwNXh-dAYQ+XkHTQaOui8RB3A@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: sysfs: fix gpio device-attribute leak
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 6:27 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Jan 13, 2015 at 9:00 PM, Johan Hovold <johan@kernel.org> wrote:
>> The gpio device attributes were never destroyed when the gpio was
>> unexported (or on export failures).
>>
>> Use device_create_with_groups() to create the default device attributes
>> of the gpio class device. Note that this also fixes the
>> attribute-creation race with userspace for these attributes.
>>
>> Remove contingent attributes in export error path and on unexport.
>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Mmm actually this one does not seem to apply to Linus' devel branch.
Seems like something has changed in between - could you rebase and
resend?
