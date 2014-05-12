Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaELSkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:40:37 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:8985 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaELSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:40:35 -0400
Message-ID: <1399920032.2648.33.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH V3] MM: make vmpressure_win dynamic
From: Davidlohr Bueso <davidlohr@hp.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, akpm <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>
Date: Mon, 12 May 2014 11:40:32 -0700
In-Reply-To: <20140512202249.8f5b8475ba2c5018585e68b1@skynet.be>
References: <20140510085217.24a34794f0e4a4881c8eec0b@skynet.be>
	 <20140512075537.GA9564@dhcp22.suse.cz>
	 <20140512202249.8f5b8475ba2c5018585e68b1@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 20:22 +0200, Fabian Frederick wrote:
> On Mon, 12 May 2014 09:55:37 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Sat 10-05-14 08:52:17, Fabian Frederick wrote:
> > > This patch addresses TODO featuring in original version :
> > 
> > This is the 3rd version of the patch and I still fail to see the
> > motivation other than addressing a TODO which doesn't sound like a
> > sufficient justification to me. Why is the new scheme needed in the
> > first place? Why is calculate_normal_threshold a proper scheme?
> Nothing more than trying to have that value dynamic.

No, that's not a valid justification. This is your reason, Fabian:

https://lkml.org/lkml/2013/1/8/45

