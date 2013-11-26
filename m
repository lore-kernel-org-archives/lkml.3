Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3KZNzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:55:12 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:48001 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3KZNzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:55:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131125180741.GA20159@roeck-us.net>
References: <1385185921-17220-1-git-send-email-linux@roeck-us.net>
	<20131125180741.GA20159@roeck-us.net>
Date: Tue, 26 Nov 2013 08:55:08 -0500
Message-ID: <CADnq5_PKAJT84csBN6AhqwhaZQu-YejfDyv=wiORwX1+03zt1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/radeon/dpm: Convert to use devm_hwmon_register_with_groups
From: Alex Deucher <alexdeucher@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 1:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Fri, Nov 22, 2013 at 09:52:00PM -0800, Guenter Roeck wrote:
>> Simplify the code and fix race condition seen because
>> attribute files were created after hwmon device registration.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> Compile tested only; unfortunately I don't have the the necessary hardware.
>>
> Update: Tested working on actual hardware.

Applied. thanks!

Alex

>
> Guenter
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
