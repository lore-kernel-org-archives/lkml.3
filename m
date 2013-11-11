Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3KKLIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:08:00 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55578 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3KKLHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:07:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPa5ym2Xz3F19fJJqNawkRLOKk6Ao6oXrzSrHU051V7p=9otA@mail.gmail.com>
References: <CAEPa5ym2Xz3F19fJJqNawkRLOKk6Ao6oXrzSrHU051V7p=9otA@mail.gmail.com>
From: Veaceslav Falico <veaceslav@falico.eu>
Date: Mon, 11 Nov 2013 12:07:30 +0100
Message-ID: <CAE3RKNng9A6Bp7wa4+6iCprwEQpzGueagLc8iob+aFabJW4nnw@mail.gmail.com>
Subject: Re: bridge not getting ip since 3.11.5 and 3.4.66
To: Mark Trompell <mark@foresightlinux.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:29 AM, Mark Trompell <mark@foresightlinux.org> wrote:
> my bridge br0 doesn't get an ip from dhcp anymore after 3.11.5 and 3.4.66,
> What information would be helpful and required to find out what's going wrong.

CC netdev

First thing would be to provide the network scheme. Do you use vlans?
Which network
cards/drivers are you using? Do you use some kind of virtualization?
Is bonding involved?

>
> Greetings
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best regards,
Veaceslav Falico
