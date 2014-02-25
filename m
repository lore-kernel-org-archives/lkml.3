Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaBYCt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:49:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:32985 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaBYCt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:49:26 -0500
Message-ID: <530C04B4.9020204@wwwdotorg.org>
Date: Mon, 24 Feb 2014 19:49:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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

I've applied this to bcm2835's for-3.15/soc branch (and squashed the
defconfig fix into it).
