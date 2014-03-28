Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaC1SIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:08:25 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62515 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaC1SIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:08:17 -0400
Message-ID: <1396030095.12610.343.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v1] net-sysfs: expose number of link up/down transitions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>, David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Weilong Chen <chenweilong@huawei.com>, Amir Vadai <amirv@mellanox.com>,
        Michael Dalton <mwdalton@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>
Date: Fri, 28 Mar 2014 11:08:15 -0700
In-Reply-To: <CAGVrzcbVwaEiSn6irSeBwJCk8QsVizNfWO2ZhMxJN8chymo_LQ@mail.gmail.com>
References: <cover.1395980768.git.decot@googlers.com>
	 <cc4b88e880d31d8d71a5c8872a64c9d665cd097e.1395980768.git.decot@googlers.com>
	 <20140328062537.GA2805@minipsycho.orion>
	 <CAGVrzcZEuTCN0gtQ6pOSgT_3cd3Z8Z4OP2jn0QOD-QHbyPsAiA@mail.gmail.com>
	 <1396028776.12610.341.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAGVrzcbVwaEiSn6irSeBwJCk8QsVizNfWO2ZhMxJN8chymo_LQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 10:59 -0700, Florian Fainelli wrote:

> What I meant is that this sort of information most likely is already
> part of some sort of machine health check that runs periodically,
> which probably collects gazillions of other metrics. Whether the link
> flapping information comes from sysfs or was maintained by a small
> script which counts link UP/DOWN events from 'ip monitor link' and
> outputs this into a file boils down to the same thing: the information
> is available to some degree.

Yeah, I am not sure such a daemon runs on my netgear/OpenWrt router ;)



