Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaI3Rm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:42:56 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:48422 "EHLO
	homiemail-a9.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbaI3Rmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:42:53 -0400
Message-ID: <1412098950.849.0.camel@linux-t7sj.site>
Subject: Re: Document POSIX MQ /proc/sys/fs/mqueue files
From: Davidlohr Bueso <dave@stgolabs.net>
To: mtk.manpages@gmail.com
Cc: Doug Ledford <dledford@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 30 Sep 2014 10:42:30 -0700
In-Reply-To: <1412098223.23497.42.camel@linux-t7sj.site>
References: <542921EA.4050709@gmail.com>
	 <1412011687.15492.39.camel@firewall.xsintricity.com>
	 <CAKgNAkj9+Z1yO-zrQ_qWFut7BqOkzNtNCruSSRyTKMpXZOcBaw@mail.gmail.com>
	 <1412098223.23497.42.camel@linux-t7sj.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 10:30 -0700, Davidlohr Bueso wrote:
> Agreed. And this needs to be changed back -- *although* there have been
> 0 bug reports afaict. Probably similarly to what we did with the
> queues_max issue: stable since v3.5. Doug, any thoughts?

Note that by changing back, I don't mean reverting your patches, just
not exporting the extra bits to QSIZE.

