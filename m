Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3LQTFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:05:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:28142 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751926Ab3LQTFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:05:05 -0500
Date: Tue, 17 Dec 2013 14:05:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tracing events with GPIOs
Message-ID: <20131217140502.2aed31aa@gandalf.local.home>
In-Reply-To: <1387304970.3051.35.camel@empanada>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	<52AFA5E0.7040707@hitachi.com>
	<CACh+v5NgwyAD5xy-feykUDXpzVUuF2yFxP35TsnGk3r+LFtRPA@mail.gmail.com>
	<1387304970.3051.35.camel@empanada>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 12:29:30 -0600
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> > Tom,
> > is git://git.yoctoproject.org/linux-yocto-contrib
> > tzanussi/event-triggers-v11 the right starting point ?
> > 
> 
> Yep, that's the last iteration - I haven't changed anything since then.
> 

Is this the same as the last patch series you sent out? I started
testing them again last week, but they failed some of my tests.
Unfortunately, I didn't get a chance to look into why. I'm hoping to
get that series out to my for-next branch by end of the week, as I'll
be taking two weeks off starting next week.

Year end crap is piling up, preventing me from getting real work
done ;-)

-- Steve
