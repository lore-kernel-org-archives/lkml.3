Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3LBXK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:10:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3LBXKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:10:55 -0500
Date: Mon, 2 Dec 2013 15:10:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 0/5] rtc: s5m: Bug fixes of the driver after tests
Message-Id: <20131202151053.40f055dabf91b0f739d65563@linux-foundation.org>
In-Reply-To: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013 09:09:38 +0100 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

> This is a second version of patchset of small but important fixes for rtc-s5m
> driver. Last patches also add waking up on RTC alarm interrupts.
> 
> The patchset is based on v3.13-rc1-229-ge7c0d3d and depends on patch from 
> Geert Uytterhoeven:
>  - rtc: s5m-rtc: Fix info->rtc assignment
>    http://article.gmane.org/gmane.linux.kernel/1595905

When Geert sent that patch he said "I would be really surprised if this
driver didn't just crash...  Please test.".  I've been waiting for
someone to test it!  Can I take it that you have done so?
