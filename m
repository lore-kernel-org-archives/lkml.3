Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbaAHTFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:05:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51798 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaAHTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:05:41 -0500
Message-ID: <52CDA181.4030005@wwwdotorg.org>
Date: Wed, 08 Jan 2014 12:05:37 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: config: enable ams AS3722 power reset driver
References: <1389084000-17033-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1389084000-17033-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 01:39 AM, Laxman Dewangan wrote:
> ams AS3722 is used as system PMIC for Tegra124 based Venice2.
> Enable ams AS3722 power reset driver for enabling power off
> system using PMIC.

I assume you'll also send a patch to add the following to DT:

			ams,system-power-controller;

