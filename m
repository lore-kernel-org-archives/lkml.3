Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3C0DUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:20:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47333 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3C0DUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:20:35 -0400
Message-ID: <51526581.8090205@wwwdotorg.org>
Date: Tue, 26 Mar 2013 21:20:33 -0600
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

This, coupled with the other two patches,
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
