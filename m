Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3KFUIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:08:14 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56208 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3KFUIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:08:13 -0500
MIME-Version: 1.0
In-Reply-To: <21114.2315.610902.200164@gargle.gargle.HOWL>
References: <21114.2315.610902.200164@gargle.gargle.HOWL>
Date: Wed, 6 Nov 2013 12:08:12 -0800
X-Google-Sender-Auth: i0Ut3iSrHbbK-1EkW_NIef5p8Mg
Message-ID: <CAE9FiQX3mGLmzFCyaHYPBA2QgvxBYr9zarXcUKa5DC0ZtiiWZw@mail.gmail.com>
Subject: Re: [BUG?] mtrr sanitizer fails on Latitude E6230
From: Yinghai Lu <yinghai@kernel.org>
To: Mikael Pettersson <mikpelinux@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 1:16 AM, Mikael Pettersson <mikpelinux@gmail.com> wrote:
> I recently got a Dell Latitude E6230 (Ivy Bridge i7-3540M) and noticed that
> the mtrr sanitizer failed on it:
>
> === snip ===
> Linux version 3.12.0 (mikpe@barley) (gcc version 4.8.3 20131017 (prerelease) (GCC) ) #1 SMP Wed Nov 6 09:46:02 CET 2013
> Command line: ro root=LABEL=/ resume=/dev/sda2 rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=sv-latin1
...
gran_size: 8M  chunk_size: 64M         num_reg: 9      lose cover RAM: 6M
...
> mtrr_cleanup: can not find optimal value
> please specify mtrr_gran_size/mtrr_chunk_size
> === snip ===
>
> For now I'm disabling the mtrr sanitizer in this machine's kernel.

Can you try to boot with "mtrr_gran_size=8m mtrr_chunk_size=64m" ?

Thanks

Yinghai
