Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbbAGObu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:31:50 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:56186 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbAGObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:31:49 -0500
MIME-Version: 1.0
In-Reply-To: <CALnsgKz7_zp76yTqp3J+ZT_bgd5s_NnDKR=oyvjurDbNkfXHBg@mail.gmail.com>
References: <CALnsgKz7_zp76yTqp3J+ZT_bgd5s_NnDKR=oyvjurDbNkfXHBg@mail.gmail.com>
Date: Wed, 7 Jan 2015 16:31:48 +0200
Message-ID: <CAHp75VfzWFi4TVVr7yNTn4CceqmkNsFv61KOz=4UwkptAunQ8A@mail.gmail.com>
Subject: Re: [Bugs] PVS-Studio dives into Linux insides (3.18.1)
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vladimir <quickcracktime@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suggested already via email to fix your tool to provide necessary
information in the log files, i.e. full pathname for each source file
you checked.
Moreover it would be nice to have file somehow grouped by checked files.


On Wed, Jan 7, 2015 at 2:42 PM, Vladimir <quickcracktime@gmail.com> wrote:
> PVS-Studio detected a bunch of bugs at Linux kernel !
> You may want to check it out and fix those bugs.
> To get more information, search for
> " PVS-Studio dives into Linux insides (3.18.1) "
> in the Internet, or use shortened l :
> bit [dot] ly/1BHsxeN
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
