Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaALT0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:26:30 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39016 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:26:27 -0500
Message-ID: <52D2EC5D.2010800@gmail.com>
Date: Sun, 12 Jan 2014 20:26:21 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/28] drm/i2c: tda998x: use irq for connection status
 and EDID read
References: <20140109120412.7697d23c@armhf> <20140111181432.GB15937@n2100.arm.linux.org.uk> <52D18EE9.5030305@gmail.com> <20140112195113.316d0c98@armhf>
In-Reply-To: <20140112195113.316d0c98@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 07:51 PM, Jean-Francois Moine wrote:
> On Sat, 11 Jan 2014 19:35:21 +0100
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>
>> At least for the DT part, I'd suggest to not ask for interrupt directly
>> but use a proper gpios property. The can of course be converted to
>> priv->int_irq in some tda998x_dt_probe.
>
> May you give me more information?

Sure, see [1].

[1] http://lists.freedesktop.org/archives/dri-devel/2013-May/038822.html

Sebastian
