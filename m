Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3IHG4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 02:56:34 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56084 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3IHG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 02:56:32 -0400
Message-ID: <522C1DF9.2060205@gmail.com>
Date: Sun, 08 Sep 2013 08:49:29 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/19] pramfs
References: <522AE04C.6000002@gmail.com>
In-Reply-To: <522AE04C.6000002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2013 10:14, Marco Stornelli ha scritto:
> Hi all,
>
> this is an attempt to include pramfs in mainline. At the moment pramfs
> has been included in LTSI kernel. Since last review the code is more
> or less the same but, with a really big thanks to Vladimir Davydov and
> Parallels, the development of fsck has been started and we have now
> the possibility to correct fs errors due to corruption. It's a "young"
> tool but we are working on it. You can clone the code from our repos:
>
> git clone git://git.code.sf.net/p/pramfs/code pramfs-code
> git clone git://git.code.sf.net/p/pramfs/Tools pramfs-Tools
>

Other comments before v2? Please let me know.

Marco

