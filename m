Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab3DBCir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:38:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59780 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3DBCip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:38:45 -0400
Message-ID: <515A44B4.7070903@wwwdotorg.org>
Date: Mon, 01 Apr 2013 20:38:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bcm2835: Add Broadcom BCM2835 RNG to the device tree
References: <1364135511-26970-1-git-send-email-lkundrak@v3.sk> <1364451124-5039-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1364451124-5039-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 12:12 AM, Lubomir Rintel wrote:
> This adds a device tree binding for random number generator present on Broadcom
> BCM2835 SoC, used in Raspberry Pi and Roku 2 devices.

FYI, I intend to apply this patch to the bcm2835 tree whenever the RNG
driver itself is applied to the hw_random tree. If you could ping me
when that happens to jog my memory, that'd be great. Thanks.
