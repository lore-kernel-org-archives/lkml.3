Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab3HGWAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:00:24 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:53964 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667Ab3HGVzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAC-DJzL0VzDxCpsdwjugavBhcFUr+kv+iN9D-Yz_tasw=DF75Q@mail.gmail.com>
References: <1374163091-4750-1-git-send-email-enselic@gmail.com>
	<CANLzEksSsMY2pTYTfGzgntF-i_Kus+WeVPyNzW0U7APcGOv_5g@mail.gmail.com>
	<CAC-DJzL0VzDxCpsdwjugavBhcFUr+kv+iN9D-Yz_tasw=DF75Q@mail.gmail.com>
Date: Wed, 7 Aug 2013 14:55:16 -0700
X-Google-Sender-Auth: xdX17v1CZR49aXc4--_276qyPuQ
Message-ID: <CANLzEkvi7PY7iO+kicCQZaSi7n6mn2JUC3hVVvPJN2LcCLnqKw@mail.gmail.com>
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


On Sun, Aug 4, 2013 at 10:32 PM, Martin Nordholts <enselic@gmail.com> wrote:
> ... I must admit I did not see this. I realize that this makes my
> patch a dead end. I wish I would have seen that earlier, that would
> have saved time for everyone. My apologies.
>
> Regarding the interaction with non-i2c devices in chromeos_laptop, I
> was thinking that could perhaps have been solved by putting the i2c
> stuff in a separate driver, say chromeos_laptop_i2c, but that point is
> irrelevant now that you pointed out that the use of the
> detect()-method is discouraged by the documentation.
>
> Thank you again for reviewing the patch and for providing feedback.

No problem at all. Thank you for your interest in our project, actually!

If you get a chance, could you let me know if my deferred probe
changes work well in your configuration?



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
