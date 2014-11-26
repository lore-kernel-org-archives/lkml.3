Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaKZHJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:09:07 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:40476 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaKZHJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:09:05 -0500
Date: Wed, 26 Nov 2014 02:09:00 -0500 (EST)
From: Jason Wang <jasowang@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <848153913.16119602.1416985740195.JavaMail.zimbra@redhat.com>
In-Reply-To: <87sih9xv5u.fsf@rustcorp.com.au>
References: <1415857974-23326-1-git-send-email-jasowang@redhat.com> <87sih9xv5u.fsf@rustcorp.com.au>
Subject: Re: [PATCH 1/2] virito: introduce methods of fixing device features
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC38 (Linux)/8.0.6_GA_5922)
Thread-Topic: virito: introduce methods of fixing device features
Thread-Index: 8y3TqUzP22XmyRFTi1NQN8tKNeX2Pw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> Jason Wang <jasowang@redhat.com> writes:
> > Buggy host may advertised buggy host features (a usual case is that host
> > advertise a feature whose dependencies were missed). In this case, driver
> > should detect and disable the buggy features by itself.
> 
> Sorry, I've been focussing elsewhere.
> 
> I would really prefer that drivers offer a "feature_depends" table,
> which can indicate that feature A depends on feature B, and have the
> core iterate, complain and fixup as necessary.
> 
> Is that expressive enough, or do we need more?
> 
> Thanks,
> Rusty.

I suggested something like this in https://lkml.org/lkml/2014/11/19/132, but
Michael does not like it ...
