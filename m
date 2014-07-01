Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaGAUnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:43:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaGAUnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:43:40 -0400
Date: Tue, 1 Jul 2014 13:43:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers: remove fs.h from poll.h
Message-Id: <20140701134338.1d221dd127ffef4c25e86800@linux-foundation.org>
In-Reply-To: <20140701200150.GA31103@p183.telecom.by>
References: <20140701200150.GA31103@p183.telecom.by>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014 23:01:50 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> fs.h is new sched.h!
> 
> Start removing unnecessary fs.h inclusions.
> 
> In the end of the whole series ~2000 useless fs.h inclusions are gone
> (just need more comple testing).
> 

This changelog is rather confusing.

The patch adds lots *more* fs.h inclusions.  I *think* the intent is to
remove one nested inclusion in poll.h.  But that contradicts your third
paragraph.

Help us out here, OK?

