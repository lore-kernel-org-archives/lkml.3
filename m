Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3LSNnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:43:31 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:58800 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3LSNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:56 -0500
Date: Thu, 19 Dec 2013 13:42:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix the header file name in some copyrights section
Message-ID: <20131219134252.GJ27373@lee--X1>
References: <1387458523-9684-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387458523-9684-1-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Laszlo Papp wrote:

> The original author(s) probably only made a copy/paste from the existing public
> header, and that is how this issue could sneak in. It is now more consistent
> with the rest where this file name is proper in the copyrights section.
> Arguably, the file name could be removed from there, but this is now just done
> for catching up with the way how it is done in certain other similar headers.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  include/linux/mfd/max77686-private.h | 2 +-
>  include/linux/mfd/max8997-private.h  | 2 +-
>  include/linux/mfd/max8998-private.h  | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

I guess we all have to start somewhere. ;)

More useful patches are more gratefully received, however.

Applied with some small changes to the commit message.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
