Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaJQQUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:20:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbaJQQUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:20:37 -0400
Date: Fri, 17 Oct 2014 18:20:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] freezer: check OOM kill while being frozen
Message-ID: <20141017162034.GI8076@dhcp22.suse.cz>
References: <20141016203954.GA26336@redhat.com>
 <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
 <20141016211136.GA27468@redhat.com>
 <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
 <20141016213512.GA28099@redhat.com>
 <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com>
 <20141016222237.GA30063@redhat.com>
 <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com>
 <20141017074654.GD8076@dhcp22.suse.cz>
 <20141017161021.GC7227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017161021.GC7227@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-10-14 18:10:21, Oleg Nesterov wrote:
> On 10/17, Michal Hocko wrote:
> >
> > I think we should rather get back to __thaw_task here.
> 
> Yes, agreed.
> 
> > Andrew could you replace the previous version by this one, please?
> 
> Yes, that patch should be dropped...

Andrew, drop all three patches. I will think about things raised here by
Oleg and come back sometimes next week.

-- 
Michal Hocko
SUSE Labs
