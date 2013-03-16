Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3CPPWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:22:52 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:56537 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3CPPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <51448AC9.7080105@gmail.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
	<51429D7A.30906@gmail.com>
	<5142ABD3.4040106@gmail.com>
	<CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
	<CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
	<51448AC9.7080105@gmail.com>
Date: Sat, 16 Mar 2013 23:22:47 +0800
Message-ID: <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 11:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>
> Hi Ming,
>
> With your patch:
>
>
> [ 1525.874312] release_sysfs_dirent sysfs_dirent use after free: ptysb-uevent

Sasha, thanks for your test.

So is the oops always triggered on this node of 'ptysb-uevent' or the node name
is changed every time?


Thanks,
-- 
Ming Lei
