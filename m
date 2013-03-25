Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3CYLCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab3CYLCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:02:23 -0400
Date: Mon, 25 Mar 2013 08:02:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Jarod Wilson <jarod@wilsonet.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: lirc: remove dead code
Message-ID: <20130325080212.6e2cb4c3@redhat.com>
In-Reply-To: <CAHj3AVk-3oRAFG4UV5-vxA_8LejUh-X7Tgi2N0xe--p13-FiCQ@mail.gmail.com>
References: <1364203632.1390.254.camel@x61.thuisdomein>
	<CAHj3AVn83fum-2BQnEKxxajdL=VLrdNQGQ2cWf7dzOYbVHiqQw@mail.gmail.com>
	<1364204910.1390.259.camel@x61.thuisdomein>
	<CAHj3AVk-3oRAFG4UV5-vxA_8LejUh-X7Tgi2N0xe--p13-FiCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 25 Mar 2013 13:59:44 +0400
Denis Kirjanov <kirjanov@gmail.com> escreveu:

> Greg, looks like you have missed it in the queue for 3.8-rc1

Greg won't likely apply it, as drivers/stating/media is maintained by me.
I'll pick it and apply, adding Paul SOB on it.

> 
> 
> 
> On 3/25/13, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Mon, 2013-03-25 at 13:40 +0400, Denis Kirjanov wrote:
> >> Just found that the exactly the same patch has been posted a while ago:
> >> http://driverdev.linuxdriverproject.org/pipermail/devel/2012-November/033623.html
> >
> > Thanks for that. Is that previous patch queued somewhere?
> >
> >
> > Paul Bolle
> >
> >
> 
> 


-- 

Cheers,
Mauro
