Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaIEQy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:54:26 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64898 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaIEQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:54:25 -0400
Date: Fri, 5 Sep 2014 18:54:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140905165421.GI26243@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140905140815.GA10455@mtj.dyndns.org>
 <CAM_iQpXJfNAfTvfWNCUrdkwSWk7e2hkpoi4rba42RP7K=aYQDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXJfNAfTvfWNCUrdkwSWk7e2hkpoi4rba42RP7K=aYQDQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-09-14 09:43:52, Cong Wang wrote:
> On Fri, Sep 5, 2014 at 7:08 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Prolly should stable@vger.kernel.org?
> 
> Oh, yes. I assume the maintainer (Michal?) will send it to stable

I guess you meant Rafael.

> once it is accepted, or I can do that after it is merged.

-- 
Michal Hocko
SUSE Labs
