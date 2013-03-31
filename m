Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3CaEJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 00:09:40 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:36774 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab3CaEJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 00:09:39 -0400
Message-ID: <1364702977.6239.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with
 find_alloc_undo
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 30 Mar 2013 21:09:37 -0700
In-Reply-To: <515791A8.7010904@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5151DBD3.6080201@oracle.com> <20130328113222.194bbfe8@cuia.bos.redhat.com>
	 <5156EA36.8050109@oracle.com> <515791A8.7010904@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-30 at 21:30 -0400, Rik van Riel wrote:
> On 03/30/2013 09:35 AM, Sasha Levin wrote:
> 
> > I'm thinking that the solution is as simple as:
> 
> Your patch is absolutely correct.  All it needs now is your
> signed-off-by, so Andrew can merge it into -mm :)
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>

Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

