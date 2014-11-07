Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaKGVlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:41:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaKGVlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:41:02 -0500
Date: Fri, 7 Nov 2014 13:41:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kernel-janitors@vger.kernel.org,
        mgorman@suse.de, ddstreet@ieee.org, jeffrey.t.kirsher@intel.com,
        yamada.m@jp.panasonic.com, kenhelias@firemail.de, oleg@redhat.com,
        akpm@linux-foundation.org, shuah.kh@samsung.com,
        valentina.manea.m@gmail.com, yann.morin.1998@free.fr,
        laijs@cn.fujitsu.com, mathieu.desnoyers@efficios.com,
        rostedt@goodmis.org, josh@joshtriplett.org, paulmck@linux.vnet.ibm.com,
        m.chehab@samsung.com, awalls@md.metrocast.net, airlied@linux.ie,
        christian.koenig@amd.com, alexander.deucher@amd.com
Subject: Re: [PATCH] Replace mentions of "list_struct" to "list_head"
Message-ID: <20141107214100.GA1640@kroah.com>
References: <1415395128-7976-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415395128-7976-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 01:18:48AM +0400, Andrey Utkin wrote:
> There's no such thing as "list_struct".
> 
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  drivers/gpu/drm/radeon/mkregtable.c  | 24 ++++++++++++------------
>  drivers/media/pci/cx18/cx18-driver.h |  2 +-
>  include/linux/list.h                 | 34 +++++++++++++++++-----------------
>  include/linux/plist.h                | 10 +++++-----
>  include/linux/rculist.h              |  8 ++++----
>  scripts/kconfig/list.h               |  6 +++---
>  tools/usb/usbip/libsrc/list.h        |  2 +-
>  7 files changed, 43 insertions(+), 43 deletions(-)

Stuff like this should be sent to the trivial maintainer...
