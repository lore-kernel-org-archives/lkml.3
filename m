Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3C0DtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:49:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58251 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3C0DtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:49:13 -0400
Message-ID: <51526C37.5070400@wwwdotorg.org>
Date: Tue, 26 Mar 2013 21:49:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3] watchdog: Add Broadcom BCM2835 watchdog timer driver
References: <1364135137-26691-1-git-send-email-lkundrak@v3.sk> <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 11:50 AM, Lubomir Rintel wrote:
> This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.

Tested-by: Stephen Warren <swarren@wwwdotorg.org>
