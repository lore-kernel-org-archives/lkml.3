Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaKUSkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:40:31 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34730 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKUSk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:40:29 -0500
Message-ID: <546F8711.70503@collabora.co.uk>
Date: Fri, 21 Nov 2014 19:40:17 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Bill Richardson <wfrichar@chromium.org>
CC: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mfd: cros_ec: Create sysfs attributes for the ChromeOS
 EC.
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk> <1416238213-15263-3-git-send-email-javier.martinez@collabora.co.uk> <20141118142645.GD24004@x1> <546DD783.2030902@collabora.co.uk> <CAEgFhe+DQrJ6HqGF1_OWZ77Qs-hZLNgX1bHpx5FOt-y-3xh8gA@mail.gmail.com>
In-Reply-To: <CAEgFhe+DQrJ6HqGF1_OWZ77Qs-hZLNgX1bHpx5FOt-y-3xh8gA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bill,

On 11/20/2014 07:16 PM, Bill Richardson wrote:
>>
>> I don't really know why there are two interfaces for this but I guess
>> that different user-space utilities use one or another. Maybe the
>> ChromiumOS folks can comment on this.
> 
> The /dev/cros_ec interface responds to ioctls and is the primary means
> by which userspace applications talk to the EC (replacing three really
> awkward bus-specific libraries). It emits a simplified version string
> when read so that humans can tell if the EC is alive and speaking the
> same protocol that the userspace app expects.
> 
> The /sys/class/chromeos/cros_ec/* tree was originally envisioned as a
> way to provide additional human-readable interfaces to a subset of the
> EC commands, but except for the lightbar it's not often used. The
> version component here shows all the version-related info that the EC
> can provide.
> 

Got it, thanks a lot for the explanation.

Best regards,
Javier


