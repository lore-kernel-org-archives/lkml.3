Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3GIOnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:43:07 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64626 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3GIOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:43:02 -0400
Date: Tue, 9 Jul 2013 07:42:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Message-ID: <20130709144259.GF2478@htj.dyndns.org>
References: <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
 <20130709131646.GC2478@htj.dyndns.org>
 <51DC136E.6020901@openvz.org>
 <20130709134558.GD2478@htj.dyndns.org>
 <51DC1FCA.3060904@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DC1FCA.3060904@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:35:54PM +0400, Konstantin Khlebnikov wrote:
> I'm not interested in QoS or proportional control. Let schedulers do it.
> I want just bandwidth control. I don't want to write a new scheduler

Well, I'm not interested in adding more half-assed stuff on top of the
existing mess.

-- 
tejun
