Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaDRR2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:28:09 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51261 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaDRR1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:27:32 -0400
MIME-Version: 1.0
In-Reply-To: <1397757570-19750-2-git-send-email-dianders@chromium.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-2-git-send-email-dianders@chromium.org>
Date: Fri, 18 Apr 2014 11:27:31 -0600
X-Google-Sender-Auth: nwFo4Rz0wKE-9h0kpMVJzBMrkmM
Message-ID: <CAPnjgZ0AabYa=VF9E=mLKYwE5YJraW2iRHCtmKNbtji58grrwA@mail.gmail.com>
Subject: Re: [PATCH 1/7] mfd: cros_ec: spi: calculate delay between transfers correctly
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        David Hendricks <dhendrix@chromium.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2014 11:59, Doug Anderson <dianders@chromium.org> wrote:
> From: David Hendricks <dhendrix@chromium.org>
>
> To avoid spamming the EC we calculate the time between the previous
> transfer and the current transfer and force a delay if the time delta
> is too small.
>
> However, a small miscalculation causes the delay period to be
> far too short. Most noticably this impacts commands with a long
> turnaround time such as EC firmware reads and writes.
>
> Signed-off-by: David Hendricks <dhendrix@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Simon Glass <sjg@chromium.org>
