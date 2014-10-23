Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaJWMx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:53:27 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60262 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757AbaJWMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:53:22 -0400
Date: Thu, 23 Oct 2014 07:53:36 -0500
From: Brian Vandre <bvandre@gmail.com>
To: gregkh@linuxfoundation.org, jic23@kernel.org,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org,
        marex@denx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: iio: adc: fix line over 80 characters
Message-ID: <20141023125336.GB10433@brian-U>
References: <cover.1413858979.git.bvandre@gmail.com>
 <cover.1413931615.git.bvandre@gmail.com>
 <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all the replies I have gotten it seems like there might not be a good path forward
with this patch.  I am starting to agree with what Daniel Baluta said above that this doesn't
make the code easier to read.  All the other suggestions don't quite fit the same style
as the rest of the file so it might just be better to leave it.

This being my first try I thank you all for your input.  It has helped me learn quite a bit.

Hopefully on the next patch I can fix something a little more meaningful!

Thanks,
Brian Vandre
