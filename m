Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938AbaKNBs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:48:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11320 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934544AbaKNBsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:48:55 -0500
Date: Thu, 13 Nov 2014 20:48:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kernel-janitors@vger.kernel.org,
        gregkh@linuxfoundation.org, mgorman@suse.de, ddstreet@ieee.org,
        jeffrey.t.kirsher@intel.com, yamada.m@jp.panasonic.com,
        kenhelias@firemail.de, oleg@redhat.com, akpm@linux-foundation.org,
        shuah.kh@samsung.com, valentina.manea.m@gmail.com,
        yann.morin.1998@free.fr, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, m.chehab@samsung.com,
        awalls@md.metrocast.net, airlied@linux.ie, christian.koenig@amd.com,
        alexander.deucher@amd.com, trivial@kernel.org
Subject: Re: [RESUBMIT] [PATCH] Replace mentions of "list_struct" to
 "list_head"
Message-ID: <20141113204841.18898f4e@gandalf.local.home>
In-Reply-To: <1415927395-11556-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <20141107214100.GA1640@kroah.com>
	<1415927395-11556-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 05:09:55 +0400
Andrey Utkin <andrey.krieger.utkin@gmail.com> wrote:

> There's no such thing as "list_struct".

I guess there isn't.

> 
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  drivers/gpu/drm/radeon/mkregtable.c  | 24 ++++++++++++------------
>  drivers/media/pci/cx18/cx18-driver.h |  2 +-
>  include/linux/list.h                 | 34 +++++++++++++++++-----------------
>  include/linux/plist.h                | 10 +++++-----
>  include/linux/rculist.h              |  8 ++++----
>  scripts/kconfig/list.h               |  6 +++---
>  tools/usb/usbip/libsrc/list.h        |  2 +-
>  7 files changed, 43 insertions(+), 43 deletions(-)
> 

