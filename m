Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaBTANk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:13:40 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64759 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaBTANi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:13:38 -0500
Date: Wed, 19 Feb 2014 19:13:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH wq/for-3.14-fixes] workqueue: ensure @task is valid
 across kthread_stop()
Message-ID: <20140220001334.GW10134@htj.dyndns.org>
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com>
 <20140218213713.GC31892@mtj.dyndns.org>
 <5304277E.4040705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5304277E.4040705@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Feb 19, 2014 at 11:39:42AM +0800, Lai Jiangshan wrote:
> > CC: stable@vger.kernel.org
> 
> I think no one hit this bug. So I add this stable TAG?
> 
> (Jason's bug-report drives me to review the workqueue harder,
> and I found this possible bug, but I think it is irrespective
> with Jason's bug-report.)

Hmm.... the issue won't happen frequently but it can happen and the
change is on the safer side.  I think it'd be better to cc stable.

Thanks.

-- 
tejun
