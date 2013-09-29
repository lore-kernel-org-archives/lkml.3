Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3I2Rpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 13:45:49 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55665 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab3I2Rpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 13:45:47 -0400
Message-ID: <52486745.9040405@gmail.com>
Date: Sun, 29 Sep 2013 19:45:41 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-i2c@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/8] [media] s5c73m3: Don't use i2c_client->driver
References: <1380444666-12019-1-git-send-email-lars@metafoo.de> <1380444666-12019-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1380444666-12019-2-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 10:50 AM, Lars-Peter Clausen wrote:
> The 'driver' field of the i2c_client struct is redundant and is going to be
> removed. The results of the expressions 'client->driver.driver->field' and
> 'client->dev.driver->field' are identical, so replace all occurrences of the
> former with the later.
>
> Signed-off-by: Lars-Peter Clausen<lars@metafoo.de>
> Cc: Kyungmin Park<kyungmin.park@samsung.com>
> Cc: Andrzej Hajda<a.hajda@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
