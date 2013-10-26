Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3JZQXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 12:23:41 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35774 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3JZQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 12:23:39 -0400
Date: Sat, 26 Oct 2013 09:23:37 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] extcon: arizona: Add defines for microphone
 detection levels
Message-ID: <20131026162337.GB7698@lee--X1>
References: <1382796618-19921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382796618-19921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013, Charles Keepax wrote:

> Improve readability by creating a define for each microphone detection
> level.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c       |   21 ++++++++++++++++-----
>  include/linux/mfd/arizona/registers.h |    9 +++++++++
>  2 files changed, 25 insertions(+), 5 deletions(-)

I haven't checked the actual 'values' of the new defines, but I assume
you know what you're doing. I like the basic premise of the patch so
I've applied it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
