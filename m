Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3KGLri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:47:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42479 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3KGLrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:47:35 -0500
Date: Thu, 7 Nov 2013 11:46:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH 3/7] ARM: ux500: Remove ATAG support for SDI (MMC)
Message-ID: <20131107114654.GF16735@n2100.arm.linux.org.uk>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org> <1383732348-18576-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383732348-18576-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:05:44AM +0000, Lee Jones wrote:
> This hasn't been used since we moved over to a Device Tree only platform.

The patch summary line is slightly off.  There's nothing here to do with
ATAGs.
