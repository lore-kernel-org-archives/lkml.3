Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3C0DA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:00:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55979 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3C0DAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:00:55 -0400
Message-ID: <515260E5.8060708@wwwdotorg.org>
Date: Tue, 26 Mar 2013 21:00:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v2] hw_random: Add Broadcom BCM2835 RNG driver
References: <1364135511-26970-1-git-send-email-lkundrak@v3.sk> <1364135980-27750-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1364135980-27750-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 08:39 AM, Lubomir Rintel wrote:
> This adds a driver for random number generator present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.

I think this looks OK from a quick glance aside from the authorship issue.

This email wasn't Cd'd to Herbert Xu, who is listed as a co-maintainer
of drivers/char/hw_random/, and looks to be more active in applying
hw_random patches than Matt. (Or, I can take this patch through the
bcm2835 ARM tree if it's ack'd by Matt or Herbert)
