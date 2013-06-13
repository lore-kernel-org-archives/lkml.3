Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab3FMDFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:05:53 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:44561 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab3FMDFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:05:51 -0400
Date: Wed, 12 Jun 2013 20:05:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Message-ID: <20130613030546.GA8468@mtj.dyndns.org>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
 <1371070996-20613-5-git-send-email-tj@kernel.org>
 <51B93038.9010202@huawei.com>
 <20130613023831.GB10979@localhost>
 <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
 <20130613024310.GC10979@localhost>
 <20130613024859.GA7432@mtj.dyndns.org>
 <20130613025202.GD10979@localhost>
 <20130613025623.GB7432@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613025623.GB7432@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 07:56:23PM -0700, Tejun Heo wrote:
> poison.  Maybe it was something which got stuck in my brain from
> before the git history or I'm just hallucinating.  Anyways, yeap,

Just checked 2.4.  It didn't poison then.  Somehow I never got that
out of my brain all these years.  #feelingancient

-- 
tejun
