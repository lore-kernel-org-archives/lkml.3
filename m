Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab3CEDRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:17:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759145Ab3CEDR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:17:29 -0500
X-IronPort-AV: E=Sophos;i="4.84,784,1355068800"; 
   d="scan'208";a="6812430"
Date: Tue, 5 Mar 2013 11:17:36 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Eric Blake <eblake@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 5/8] add a new qevent: QEVENT_GUEST_PANICKED
Message-ID: <20130305031736.GO16362@localhost.localdomain>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <664d63ad19ae6ec25a5a7bd6411c8ab7e289f632.1362051582.git.hutao@cn.fujitsu.com>
 <5130D7F3.8070003@redhat.com>
MIME-Version: 1.0
In-Reply-To: <5130D7F3.8070003@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 11:16:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 11:16:27,
	Serialize complete at 2013/03/05 11:16:27
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 09:31:47AM -0700, Eric Blake wrote:
> On 02/28/2013 05:13 AM, Hu Tao wrote:
> > This event will be emited when the guest is panicked.
> > 
> > Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> > ---
> >  include/monitor/monitor.h | 1 +
> >  monitor.c                 | 1 +
> >  2 files changed, 2 insertions(+)
> 
> Missing documentation in QMP/qmp-events.txt

Thanks, will add it.
