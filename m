Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256Ab3DBUZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:25:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761031Ab3DBUZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:25:20 -0400
Date: Tue, 2 Apr 2013 16:25:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130402202505.GK29506@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
 <1364923183-316-4-git-send-email-yinghai@kernel.org>
 <20130402180606.GI29506@redhat.com>
 <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
 <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
 <20130402191130.GB31760@redhat.com>
 <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
 <20130402201148.GJ29506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402201148.GJ29506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 04:11:48PM -0400, Vivek Goyal wrote:

[..]
> > No, that is not just disable. User could want more like 128M instead of 72M.

So apart from swiotlb, are there other scenarios where we need to reserve
low memory (With main memory reserved high).

Thanks
Vivek
