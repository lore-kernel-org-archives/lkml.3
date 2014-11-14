Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaKNUYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:24:20 -0500
Received: from lists.s-osg.org ([54.187.51.154]:44994 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbaKNUYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:24:17 -0500
Date: Fri, 14 Nov 2014 18:24:05 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>, linux-usb@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kernel-janitors@vger.kernel.org, gregkh@linuxfoundation.org,
        mgorman@suse.de, ddstreet@ieee.org, jeffrey.t.kirsher@intel.com,
        yamada.m@jp.panasonic.com, kenhelias@firemail.de, oleg@redhat.com,
        akpm@linux-foundation.org, shuah.kh@samsung.com,
        valentina.manea.m@gmail.com, yann.morin.1998@free.fr,
        laijs@cn.fujitsu.com, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, paulmck@linux.vnet.ibm.com,
        awalls@md.metrocast.net, airlied@linux.ie, christian.koenig@amd.com,
        alexander.deucher@amd.com, trivial@kernel.org
Subject: Re: [RESUBMIT] [PATCH] Replace mentions of "list_struct" to
 "list_head"
Message-ID: <20141114182405.233f0fe3@recife.lan>
In-Reply-To: <20141113204841.18898f4e@gandalf.local.home>
References: <20141107214100.GA1640@kroah.com>
	<1415927395-11556-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<20141113204841.18898f4e@gandalf.local.home>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 13 Nov 2014 20:48:41 -0500
Steven Rostedt <rostedt@goodmis.org> escreveu:

> On Fri, 14 Nov 2014 05:09:55 +0400
> Andrey Utkin <andrey.krieger.utkin@gmail.com> wrote:
> 
> > There's no such thing as "list_struct".
> 
> I guess there isn't.

Indeed ;)
> 
> > 
> > Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> 
> -- Steve
> 
> > ---
> >  drivers/gpu/drm/radeon/mkregtable.c  | 24 ++++++++++++------------
> >  drivers/media/pci/cx18/cx18-driver.h |  2 +-
> >  include/linux/list.h                 | 34 +++++++++++++++++-----------------
> >  include/linux/plist.h                | 10 +++++-----
> >  include/linux/rculist.h              |  8 ++++----
> >  scripts/kconfig/list.h               |  6 +++---
> >  tools/usb/usbip/libsrc/list.h        |  2 +-
> >  7 files changed, 43 insertions(+), 43 deletions(-)
> > 
> 
