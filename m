Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3HKWom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 18:44:42 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:51807 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3HKWoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 18:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAC-DJz+Q=O9hvj1QoaZkhSZ-e6ueUQHUuMntin=GYdLqwV0VtA@mail.gmail.com>
References: <1374163091-4750-1-git-send-email-enselic@gmail.com>
	<CANLzEksSsMY2pTYTfGzgntF-i_Kus+WeVPyNzW0U7APcGOv_5g@mail.gmail.com>
	<CAC-DJzL0VzDxCpsdwjugavBhcFUr+kv+iN9D-Yz_tasw=DF75Q@mail.gmail.com>
	<CANLzEkvi7PY7iO+kicCQZaSi7n6mn2JUC3hVVvPJN2LcCLnqKw@mail.gmail.com>
	<CAC-DJz+Q=O9hvj1QoaZkhSZ-e6ueUQHUuMntin=GYdLqwV0VtA@mail.gmail.com>
Date: Sun, 11 Aug 2013 15:44:36 -0700
X-Google-Sender-Auth: TKpN1ZNe3iCj3G8mINo-ozbny3Y
Message-ID: <CANLzEkumGkXfvWNG+MsMV9Vaq=_bywoQF91J39mV3S2jBW1KFg@mail.gmail.com>
Subject: Re: [PATCH 0/1] Platform: x86: chromeos_laptop - convert to
 i2c_driver to handle i915 race
From: Benson Leung <bleung@chromium.org>
To: Martin Nordholts <enselic@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Olof Johansson <olof@lixom.net>, Yufeng Shen <miletus@chromium.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,


On Sun, Aug 11, 2013 at 12:54 PM, Martin Nordholts <enselic@gmail.com> wrote:
> I get this in dmesg --level err
> (--notime) though
>
> find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus vga not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus vga not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus vga not found on system.
> find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
>
> Personally I don't like getting error messages when the driver works
> as designed. I would prefer to have priority lowered to 'notice' on
> those.

Sounds good to me. I'll make this change.

Thanks again!
Benson

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
