Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbbARDGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 22:06:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57075 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbARDGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 22:06:36 -0500
Message-ID: <54BB233A.10902@wwwdotorg.org>
Date: Sat, 17 Jan 2015 20:06:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stefan Wahren <stefan.wahren@i2se.com>, lee@kernel.org
CC: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] ARM: bcm2835: Use pinctrl header
References: <1421426993-27264-1-git-send-email-stefan.wahren@i2se.com>
In-Reply-To: <1421426993-27264-1-git-send-email-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 09:49 AM, Stefan Wahren wrote:
> This patch converts all bcm2835 dts files to use the pinctrl
> header file.

Aside from the one comment I made, the series,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
