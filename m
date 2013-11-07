Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3KGMpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:45:08 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:64451 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3KGMpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:45:04 -0500
MIME-Version: 1.0
In-Reply-To: <1381145866-445-1-git-send-email-treding@nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 7 Nov 2013 13:44:38 +0100
Message-ID: <CAH9NwWei-PQQKNqB51eTqh_3z+JXxbGNp7PCnsStrVF7Dg_s5w@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] pwm-backlight: Add GPIO and power supply support
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry


> This series adds the ability to specify a GPIO and a power supply to
> enable a backlight.


Whats the state of this patch set? I am looking for this kind of
functionality for a pwm based
backlight on a devicetree only imx6 device.

greets
--
Christian Gmeiner, MSc
