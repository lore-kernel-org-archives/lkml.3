Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaDFM2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 08:28:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbaDFM21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 08:28:27 -0400
Date: Sun, 6 Apr 2014 14:28:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>, jwboyer@fedoraproject.org,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Pick up libdw without explicit LIBDW_DIR
Message-ID: <20140406122822.GF1164@krava.brq.redhat.com>
References: <1395873845-466-1-git-send-email-artagnon@gmail.com>
 <CALkWK0kcg0SWrwF0w51L5XuwsBvDO2DZ9em4eYdebo4fjEBAZQ@mail.gmail.com>
 <CAFrcx1njU6Ycia0R7ckSy5V5eoquC7OiAcGOSOHvM2srW5Jn4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1njU6Ycia0R7ckSy5V5eoquC7OiAcGOSOHvM2srW5Jn4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:46:28AM +0200, Jean Pihet wrote:
> On 3 April 2014 23:51, Ramkumar Ramachandra <artagnon@gmail.com> wrote:
> > Ramkumar Ramachandra wrote:
> >>  tools/perf/config/Makefile | 5 ++---
> >>  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > Jiri, any comments?

hi,
sorry for late reply, I was out last week

> Note: this patch is equivalent to '[PATCH] perf tools: Fix feature
> check for libdw dwarf unwind' [1] from Josh Boyer. Jiri, your pick ;-)
> 
> [1] http://www.spinics.net/lists/kernel/msg1716729.html
> 
> FWIW:
> Acked-by: Jean Pihet <jean.pihet@linaro.org>

I'll take Ramkumar's change, because he sent it out first ;-)

thanks,
jirka
