Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3H3TGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3H3TGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:06:49 -0400
Date: Fri, 30 Aug 2013 15:06:46 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: audit looks unmaintained? [was: Re: [PATCH 11/12] pid: rewrite task
 helper functions avoiding task->pid and task->tgid]
Message-ID: <20130830190646.GA30331@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822200555.GN31370@twins.programming.kicks-ass.net>
 <20130822214347.GB21110@madcap2.tricolour.ca>
 <20130823192807.GA6504@redhat.com>
 <20130827030448.GE21110@madcap2.tricolour.ca>
 <20130827171134.GB29147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827171134.GB29147@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 07:11:34PM +0200, Oleg Nesterov wrote:
> Btw. audit looks unmaintained... if you are going to take care of
> this code, perhaps you can look at
> 
> 	http://marc.info/?l=linux-kernel&m=137589907108485
> 	http://marc.info/?l=linux-kernel&m=137590271809664

(I don't want to lose these refs...  First I've seen these.)

Why do you say this?  Could you elaborate?  Due to the state of the code
itself, or the lack of response from audit folks?  (Like most, I'm not
subscribed to that firehose, so I don't have archives that show
addressees.)  Most of the kernel audit folks are on
linux-audit@redhat.com list.

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
