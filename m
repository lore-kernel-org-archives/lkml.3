Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819Ab3DCG2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:28:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36669 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762310Ab3DCG23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:28:29 -0400
Message-ID: <515BCC0C.7080701@wwwdotorg.org>
Date: Wed, 03 Apr 2013 00:28:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm: Add Broadcom BCM2835 RNG driver to bcm2835_defconfig
References: <1364135980-27750-1-git-send-email-lkundrak@v3.sk> <1364136074-27884-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1364136074-27884-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 08:41 AM, Lubomir Rintel wrote:
> This enables a driver for random number generator present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.

Squashed into bcm2835's for-3.10/defconfig branch.

(Lubomir: defconfig updates get squashed to avoid too many patches
churning that file and causing annoyance)
