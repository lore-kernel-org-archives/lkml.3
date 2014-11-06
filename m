Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaKFFME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:12:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46548 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaKFFMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:12:00 -0500
Message-ID: <545B031E.9070409@wwwdotorg.org>
Date: Wed, 05 Nov 2014 22:11:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>, lee@kernel.org
CC: linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
In-Reply-To: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 04:45 PM, Matthias Klein wrote:
> The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
> I2S interface.

Tested-by: Stephen Warren <swarren@nvidia.com>

(On a model B rev 2, UART, SD card, and enumeration of built-in USB
devices works fine)

Lee, how do you want to handle patches - will you apply them to the git
repo?

Matthias, BTW, you should CC linux-arm-kernel@lists.infradead.org too;
possibly you can use that to replace the main
linux-kernel@vger.kernel.org mailing list.
