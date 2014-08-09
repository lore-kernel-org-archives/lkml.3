Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaHIOe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:34:56 -0400
Received: from linuxhacker.ru ([217.76.32.60]:43465 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaHIOez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:34:55 -0400
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu protected current->real_parent field
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140809140426.GA20995@kroah.com>
Date: Sat, 9 Aug 2014 10:34:36 -0400
Cc: Peng Tao <bergwolf@gmail.com>, Evgeny Budilovsky <budevg@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lai Siyao <lai.siyao@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <A562EF9C-0B1E-48B2-BAB5-544C9AAC6DD0@linuxhacker.ru>
References: <87k36ltoob.fsf@gmail.com> <20140806214216.GA16530@kroah.com> <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com> <20140808034951.GA6626@kroah.com> <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru> <20140808044246.GA3084@kroah.com> <1FE03450-A256-4A18-85AB-6332A28E3EF5@linuxhacker.ru> <20140808053246.GA13588@kroah.com> <CA+a=Yy4SqXSe667DkU3KA80tAt5D=KG-9mfccvEwtJzuFr6vBA@mail.gmail.com> <20140809140426.GA20995@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Because maybe these stats preceed the introduction of perf and other
> tracing/debug tools?  I don't know, it's really low down on the list of
> reasons why lustre can't be merged out of staging at the moment, you all
> have much bigger issues to address first.

I wonder what is the prioritized list you have in mind?

Bye,
    Oleg
