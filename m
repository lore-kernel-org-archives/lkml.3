Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaDONSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaDONSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:18:06 -0400
Date: Tue, 15 Apr 2014 15:17:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>, dsahern@gmail.com
Subject: Re: [PULL 0/2] small perf fixes
Message-ID: <20140415131758.GA27607@krava.brq.redhat.com>
References: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
 <534D2E7E.4090904@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D2E7E.4090904@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:05:02PM +0200, Christian Borntraeger wrote:
> On 09/04/14 16:21, Christian Borntraeger wrote:
> > Ingo, Arnaldo,
> > 
> > two fixes indentified during kvm on s390 development are available 
> > 
> > since commit 538592ff0b008237ae88f5ce5fb1247127dc3ce5:
> > 
> >   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-03-19 08:05:47 +0100)
> > 
> > in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/perf-fixes
> > 
> > for you to fetch changes up to 5e032c6c3eaf499460e3ca6b9586c7605c16004e:
> > 
> >   perf-kvm: fix of 'Min time' counting in report command (2014-04-09 16:06:15 +0200)
> > 
> > Please consider to apply.
> > 
> > ----------------------------------------------------------------
> > Provide two fixes for perf:
> > - allow "-" in trace names. This enables perf to also handle kvm-s390
> > - fix min accounting in for perf kvm
> > 
> > ----------------------------------------------------------------
> > Alexander Yarygin (2):
> >       perf/tool: Fix usage of trace events with '-' in trace system name.
> >       perf-kvm: fix of 'Min time' counting in report command
> > 
> >  tools/perf/builtin-kvm.c       |    1 +
> >  tools/perf/util/parse-events.l |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> 
> Ping.

hi,
I'll take care of this.. tomorrow ;-)

thanks,
jirka
