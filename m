Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3F3Siq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 14:38:46 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38852 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3F3Sim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 14:38:42 -0400
Date: Sun, 30 Jun 2013 20:38:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Tim Hockin <thockin@hockin.org>,
        Mike Galbraith <bitbucket@online.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130630183838.GB23731@dhcp22.suse.cz>
References: <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <20130628180155.GD16483@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628180155.GD16483@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-06-13 14:01:55, Vivek Goyal wrote:
> On Fri, Jun 28, 2013 at 05:05:13PM +0200, Michal Hocko wrote:
[...]
> > OK, so libcgroup's rules daemon will still work and place my tasks in
> > appropriate cgroups?
> 
> Do you use that daemon in practice?

I am not but my users do. And that is why I care.

> For user session logins, I think systemd has plans to put user
> sessions in a cgroup (kind of making pam_cgroup redundant).
> 
> Other functionality rulesengined was providing moving tasks automatically
> in a cgroup based on executable name. I think that was racy and not
> many people had liked it.

It doesn't make sense for short lived processes, all right, but it can
be useful for those that live for a long time.
 
> IIUC, systemd can't disable access to cgroupfs from other utilities.

The previous messages read otherwise. And that is why this rised the red
flag at many fronts.

> So most likely rulesengined should contine to work. But having both
> systemd and libcgroup might not make much sense though.
> 
> Thanks
> Vivek

-- 
Michal Hocko
SUSE Labs
