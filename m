Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3C0Tu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:50:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab3C0Tuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:50:55 -0400
Date: Wed, 27 Mar 2013 12:50:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] idr: add idr_alloc_cyclic and convert existing
 cyclic users
Message-Id: <20130327125053.45a90e31186ac968bed644a4@linux-foundation.org>
In-Reply-To: <20130327193847.GF7395@htj.dyndns.org>
References: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
	<20130327193847.GF7395@htj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013 12:38:47 -0700 Tejun Heo <tj@kernel.org> wrote:

> On Wed, Mar 27, 2013 at 03:29:32PM -0400, Jeff Layton wrote:
> > (Andrew, I think this is probably best routed via -mm since it touches
> > several different places)
> 
> Yeap, I think it'd be best to route these through -mm.
> 
> Please feel free to add Reviewed-by: Tejun Heo <tj@kernel.org> for the
> whole series.

I understand that Jeff will be sending a v2 series?

btw, I'll be away-from-keyboard until the end of next week.  Nobody be
alarmed ;)

