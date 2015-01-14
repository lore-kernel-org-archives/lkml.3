Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbbANLls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:41:48 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:65461 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbANLlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <1420134593-690-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420134593-690-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 14 Jan 2015 12:41:45 +0100
Message-ID: <CACRpkdY2namg-b1Qb0yHyR_043H4cVaUEPMhkG4kb=SJhrAjBg@mail.gmail.com>
Subject: Re: [PATCH] mfd: db8500-prcmu: Remove unused function
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 6:49 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove the function prcmu_get_boot_status() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
