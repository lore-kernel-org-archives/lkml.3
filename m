Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaKEFAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 00:00:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKEFA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 00:00:28 -0500
Message-ID: <5459AEEA.8050503@wwwdotorg.org>
Date: Tue, 04 Nov 2014 22:00:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Scott Branden <sbranden@broadcom.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>, Piotr Krol <pietrushnic@gmail.com>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, linux-rpi-kernel@lists.infradead.org,
        Ray Jui <rjui@broadcom.com>, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCHv2 5/5] mmc: sdhci-bcm2835: add sdhci quirk SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12
References: <Scott Branden <sbranden@broadcom.com> <1414651017-3545-1-git-send-email-sbranden@broadcom.com> <1414651017-3545-6-git-send-email-sbranden@broadcom.com>
In-Reply-To: <1414651017-3545-6-git-send-email-sbranden@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 12:36 AM, Scott Branden wrote:
> SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 is missing and needed for this controller.

This seems fine, although any explanation of why this quirk is needed
would be useful.
