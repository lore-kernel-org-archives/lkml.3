Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbaD3UfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:35:12 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:56555 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759042AbaD3UfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:35:11 -0400
Date: Wed, 30 Apr 2014 22:35:07 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: add support for maxim dallas rtc ds1343 and ds1344
Message-ID: <20140430223507.0c011284@linux.lan.towertech.it>
In-Reply-To: <1398875107-19450-1-git-send-email-ravi23ganiga@gmail.com>
References: <1398875107-19450-1-git-send-email-ravi23ganiga@gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 21:55:07 +0530
Raghavendra Ganiga <ravi23ganiga@gmail.com> wrote:

> +
> +static int ds1343_proc(struct device *dev, struct seq_file *seq)
> +{
> +	struct ds1343_priv *priv = dev_get_drvdata(dev);
> +	unsigned int data;
> +	unsigned char alarm_mode = 0;
> +	const char *alarm_str, *diodes = "disabled", *resistors = " ";
> +
> +	regmap_read(priv->map, DS1343_CONTROL_REG, &data);

 is this thing really useful? what about having sysfs entries
 instead?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

