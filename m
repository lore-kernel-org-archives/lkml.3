Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab3CHVzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:55:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab3CHVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:55:42 -0500
Date: Fri, 8 Mar 2013 13:55:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ard van Breemen <ard@telegraafnet.nl>
Subject: Re: [PATCH v2] init: Scream bloody murder if interrupts are enabled
 too early
Message-Id: <20130308135540.0739f48551fc600604607c99@linux-foundation.org>
In-Reply-To: <1362754092.31874.97.camel@gandalf.local.home>
References: <1362754092.31874.97.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Mar 2013 09:48:12 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> Also, while examining other warnings in init/main.c, I found two other
> locations that deserve a bloody murder scream if their conditions are
> hit, and updated them accordingly.

So the whole effect of this patch is to spew a larger volume of
unuseful stuff (such as uninteresting stack traces) onto the console so
people are more likely to notice it?  Hmpf.  I think I prefer

akpm3:/usr/src/25> banner "OMG\!\!"      
####### #     #  #####    ###     ###
#     # ##   ## #     #   ###     ###
#     # # # # # #         ###     ###
#     # #  #  # #  ####    #       #
#     # #     # #     #
#     # #     # #     #   ###     ###
####### #     #  #####    ###     ###


Maybe we should reduce the amount of goop we printk out at boot
instead ;)

