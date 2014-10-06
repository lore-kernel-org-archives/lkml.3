Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaJFNQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbaJFNQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:16:07 -0400
Date: Mon, 6 Oct 2014 14:24:46 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20141006132445.GA18339@agordeev.usersys.redhat.com>
References: <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
 <20141001153114.GE8971@agordeev.usersys.redhat.com>
 <20141005022311.GD8549@htj.dyndns.org>
 <20141005161646.GB22223@mtj.dyndns.org>
 <20141006072710.GH8971@agordeev.usersys.redhat.com>
 <20141006125817.GA18303@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006125817.GA18303@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 08:58:17AM -0400, Tejun Heo wrote:
> I don't think we'd be able to move libata handling to block softirq
> and probably end up just doing it from the irq context.  Anyways, as
> long as you're gonna keep working on it, I have no objection to the
> proposed changes.  Do you have a refreshed version or is the current
> version good for inclusion?

No, this one would not apply. I can send updated version on top of
v5 I posted earlier. Should I?

> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
