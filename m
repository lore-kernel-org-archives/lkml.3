Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaHTDN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:13:57 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:62453 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaHTDN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:13:56 -0400
MIME-Version: 1.0
In-Reply-To: <53F40CF8.8050504@linux.intel.com>
References: <alpine.DEB.2.19.4.1408191754390.2758@trent.utfs.org>
	<53F40CF8.8050504@linux.intel.com>
Date: Tue, 19 Aug 2014 20:13:55 -0700
Message-ID: <CAM_iQpWMtakj2QUEsF3NdzHyD-VULCkgMR4yf5VrPPBm03joEg@mail.gmail.com>
Subject: Re: WARNING: CPU: 6 PID: 79 at fs/proc/generic.c:521 remove_proc_entry+0x170/0x180()
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 7:50 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Hi Kujau,
>         It seems like a different issue, something wrong with
> void nfs_fs_proc_net_exit(struct net *net)

http://marc.info/?l=linux-nfs&m=140821782107427&w=2
