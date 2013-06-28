Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3F1WnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:43:18 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41850 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3F1WnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:43:16 -0400
Date: Fri, 28 Jun 2013 15:43:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Tim Hockin <thockin@hockin.org>,
        Mike Galbraith <bitbucket@online.de>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter <lpoetter@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>,
        workman-devel <workman-devel@redhat.com>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130628224310.GF18889@mtj.dyndns.org>
References: <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <20130628180155.GD16483@redhat.com>
 <20130628195917.GG2507@redhat.com>
 <20130628224053.GA9426@tp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628224053.GA9426@tp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 05:40:53PM -0500, Serge Hallyn wrote:
> > The kernel can exposed a knob that would allow systemd to lock that
> > down
> 
> Gah - why would you give him that idea?  :)

That's one of the ideas I had from the beginning.

> But yes, I'd sort of assume that was coming, eventually.

But I think we'll probably settle with a mechanism to find out whether
someone else is touching the hierarchy, which will be generally useful
for other consumers of cgroup too.

Thanks.

-- 
tejun
