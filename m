Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3JKOPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:15:23 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45826 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3JKOPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <1380916902-23791-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
	<1380916902-23791-2-git-send-email-david.a.cohen@linux.intel.com>
Date: Fri, 11 Oct 2013 16:15:21 +0200
Message-ID: <CACRpkdbMboD_Z1nnzTDhfqDPjNCpMiymgufiy75KDUxyNK--vA@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio: langwell: add Intel Merrifield support
From: Linus Walleij <linus.walleij@linaro.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Fei Yang <fei.yang@intel.com>, Ning Li <ning.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 10:01 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:

> This patch implements a better way to handle multiple SoC's and adds
> Intel Merrifield support to gpio-langwell.
>
> It was based on previous work from Ning Li <ning.li@intel.com>
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Signed-off-by: Fei Yang <fei.yang@intel.com>
> Signed-off-by: Ning Li <ning.li@intel.com>

I would have liked some ACK, but the code looks really tasty
so patch applied.

Yours,
Linus Walleij
