Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAMUhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:37:10 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:54833 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaAMUhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:37:08 -0500
X-Auth-Info: FL4aiw4sEJJ1zgT8n7/9oDKV0OZqB5OjOric3Mf8qzc=
From: Marek Vasut <marex@denx.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH 2/3] iio: mxs-lradc: fix invalid channel number detection
Date: Mon, 13 Jan 2014 21:25:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com> <1389628923-8689-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1389628923-8689-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201401132125.37243.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 13, 2014 at 05:02:02 PM, Alexandre Belloni wrote:
> 16 would be accepted as a channel number but it is invalid. It doesn't
> really have any effect as mxs_lradc_read_raw is called from a "controlled"
> environment so it it only gets values going from 0 to 15.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Why don't you remove the check entirely then ?

Best regards,
Marek Vasut
