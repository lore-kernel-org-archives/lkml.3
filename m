Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3KNOgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:36:22 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54982 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3KNOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:36:14 -0500
Date: Thu, 14 Nov 2013 14:36:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] extcon: arizona: Add defines for microphone
 detection levels
Message-ID: <20131114143606.GA4996@lee--X1>
References: <1384438297-27851-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384438297-27851-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013, Charles Keepax wrote:

> Improve readability by creating a define for each microphone detection
> level.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c       |   19 ++++++++++++++-----
>  include/linux/mfd/arizona/registers.h |    9 +++++++++
>  2 files changed, 23 insertions(+), 5 deletions(-)

You've missed off my Ack for the MFD parts.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
