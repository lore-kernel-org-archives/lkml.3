Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaGGPxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:53:01 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:50308 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaGGPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:52:59 -0400
MIME-Version: 1.0
In-Reply-To: <1403801926-22996-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403801926-22996-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:52:59 +0200
Message-ID: <CACRpkdaPy=oyp6Kjbmw2LRJhQ90W6b5Y3d5+ed+WdHwPMeOeBQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-single.c: Cleaning up wrong format
 string usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ext Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 6:58 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> %d in format string used, but the type is unsigned int
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Patch applied.

Yours,
Linus Walleij
