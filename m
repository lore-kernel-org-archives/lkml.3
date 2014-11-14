Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161165AbaKNQCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:02:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46346 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161017AbaKNQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:02:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141114131448.GC21209@htj.dyndns.org>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
 <1415906662-4576-10-git-send-email-bobby.prani@gmail.com> <20141114131448.GC21209@htj.dyndns.org>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 14 Nov 2014 11:02:10 -0500
Message-ID: <CAJhHMCB1+XtXGjP-GhVN1+TPto+cfZYAwAXg+P+tpAmytynSuQ@mail.gmail.com>
Subject: Re: [PATCH 09/16] percpu: Replace smp_read_barrier_depends() with lockless_dereference()
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 8:14 AM, Tejun Heo <tj@kernel.org> wrote:
>
> How should this be routed?  There's a pending change on the same
> region of code and if this patch is routed outside percpu tree it'd
> cause a conflict and I can't route this as lockless_dereference()
> isn't in the mainline yet.  Maybe expose a git branch which contaisn
> lockless_dereference() so that percpu can pull it in?
>

I do not have access to git hosting (except github, but I think that
is not acceptable). May be once the patches are final, I can send in a
version which you can put in a branch on kernel.org?

-- 
Pranith
