Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaA1Goc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:44:32 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48316 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaA1Gob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:44:31 -0500
Date: Mon, 27 Jan 2014 22:44:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Luis Ortega <luiorpe1@upv.es>
Cc: heiko@sntech.de, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Input: zforce - fix various small issues
Message-ID: <20140128064427.GA16142@core.coreip.homeip.net>
References: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 07:46:09PM +0100, Luis Ortega wrote:
> As a kernel newbie and owner of a Barnes & Noble e-reader I was
> curious to review this driver to learn more about the touchscreen.
> 
> The first two patches are fairly innocuous whereas the last two
> slightly modify the code to fix two small issues I discovered.
> I don't have the setup to test them but they look logically correct
> to me.
> 
> [PATCH 1/4] Input: zforce - fix spelling errors
> [PATCH 2/4] Input: zforce - fix lines exceeding 80 columns
> [PATCH 3/4] Input: zforce - Remove unnecessary payload data checks
> [PATCH 4/4] Input: zforce - reduce stack memory allocated to frames

Applied all 4, thank you.

-- 
Dmitry
