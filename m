Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935232Ab3IDPo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:44:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934868Ab3IDPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:44:27 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=zOSXuZH0-soA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JMugIRAljVAA:10 a=nEyH1i0ZFpS9y60KsbAA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 4 Sep 2013 11:44:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 03/25] avr32: Use Kbuild infrastructure to handle
 asm-generic headers
Message-ID: <20130904114426.72b979c5@gandalf.local.home>
In-Reply-To: <20130901205551.GA21140@samfundet.no>
References: <20121013022632.024527228@goodmis.org>
	<20121013022952.855483404@goodmis.org>
	<20130901205551.GA21140@samfundet.no>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Sep 2013 22:55:51 +0200
Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:

> Around Fri 12 Oct 2012 22:26:35 -0400 or thereabout, Steven Rostedt wrote:
> 
> Hello Steven,
> 
> > Use Kbuild infrastructure to handle the asm-generic headers
> > and remove the wrapper headers that call them.
> > 
> > This only affects headers that do nothing but include the generic
> > equivalent. It does not touch any header that does a little more.
> 
> Thank you for cleaning. A bit old this patch (yikes, almost a year), but I
> cleaned it up a bit, and added it to my for-linus branch.
> 

Thanks,

-- Steve
