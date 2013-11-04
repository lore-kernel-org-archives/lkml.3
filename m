Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3KDMHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:07:32 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34596 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3KDMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:07:31 -0500
MIME-Version: 1.0
In-Reply-To: <1383018645-10019-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1383018645-10019-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Mon, 4 Nov 2013 13:07:31 +0100
Message-ID: <CACRpkdaoVR+Fkt2bX65KCQxSDvKNy_BoGNB=dNW9uzfT2GSE-Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: remove minor dead code
From: Linus Walleij <linus.walleij@linaro.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 4:50 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:

> This removes a test whether the 'desc' variable is NULL.
> This possibility has already been eliminated by the
> below test earlier in the loop:
>
>                 if (desc == NULL) {
>                         dev_warn(pctldev->dev,
>                                  "could not get pin desc for pin %d\n",
>                                  pins[i]);
>                         continue;
>                 }
>
> Found with Coverity: CID #1090078
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Pretty cool find!

Patch applied.

Yours,
Linus Walleij
