Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaGIKUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:20:50 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50565 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbaGIKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <1404760102-24471-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404760102-24471-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 9 Jul 2014 12:20:47 +0200
Message-ID: <CACRpkdYDOVg+9QDQ74NAP9HM-C-XYd6_trV-E9jAjS0LNBB2Hg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: pinctrl-msm.c: Cleaning up variable that is
 never used
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 9:08 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Aw sorry - the disable() functions were all deleted in another
patch set so this is no longer a problem.

I should have noticed at once, but my brain is a bit messy due
to too many things to think about :-/

Yours,
Linus Walleij
