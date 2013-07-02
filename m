Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab3GBGwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:52:17 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48603 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3GBGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130627111518.GX27646@sirena.org.uk>
References: <1372316213-30671-1-git-send-email-ks.giri@samsung.com>
	<20130627111518.GX27646@sirena.org.uk>
Date: Tue, 2 Jul 2013 12:22:14 +0530
Message-ID: <CAKrE-KcOVCipc9BfmVgvg5BAgKv2=V0F6WhFqFWP6vsLy7OOKA@mail.gmail.com>
Subject: Re: [PATCH] spi: s3c64xx: add missing check for polling mode
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 4:45 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jun 27, 2013 at 12:26:53PM +0530, Girish K S wrote:
>> After the patch "spi/s3c64xx: Fix non-dmaengine usage"
>> with commit id 563b444e33810f3120838620c990480304e24e63
>> submitted by Mark Brown, the spi device detection in polling
>> mode breaks. This revealed the missing check for polling during
>> dma prepare. This patch adds the missing check.
>
> Applied with a fixed commit message - since the dmaengine stuff was
> already in mainline at the time that polling mode was added the isse was
> that the patch hadn't been tested with current mainline code.

Hello Mark, This patch is missing in your pull request for 3.11. is it
possible to add it?
