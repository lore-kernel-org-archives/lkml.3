Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3EQC7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:59:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57440 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3EQC7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:59:21 -0400
Message-ID: <51959D07.3010509@wwwdotorg.org>
Date: Thu, 16 May 2013 20:59:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v4] watchdog: Add Broadcom BCM2835 watchdog timer driver
References: <1364320200-23569-1-git-send-email-lkundrak@v3.sk> <1364402424-19503-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1364402424-19503-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 10:40 AM, Lubomir Rintel wrote:
> This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.

Lubomir, I don't believe this patch was applied for 3.10. Are you
planning to fix up any remaining issues and repost for 3.11?
