Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaBUEyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:54:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34471 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBUEx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:53:58 -0500
Message-ID: <5306DBE4.8090106@wwwdotorg.org>
Date: Thu, 20 Feb 2014 21:53:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Markus Mayer <markus.mayer@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>
CC: ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: bcm2835: Move to mach-bcm directory
References: <1392941771-15774-1-git-send-email-markus.mayer@linaro.org>
In-Reply-To: <1392941771-15774-1-git-send-email-markus.mayer@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 05:16 PM, Markus Mayer wrote:
> Move the bcm2835 board file into the mach-bcm directory. This allows us
> to get rid of the mach-bcm2835 directory with the associated Kconfig
> and Makefile.

This looks fine, although it needs a small patch to bcm2835_defconfig
squashed in, which I'll post in a second.

Do you want me to take it through the bcm2835 tree? That's probably
easiest to avoid conflicts with any other bcm2835 patches, not that it's
too likely there will be any to the board file.
