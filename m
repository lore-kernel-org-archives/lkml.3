Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaCUX1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:27:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaCUX1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:27:42 -0400
Date: Fri, 21 Mar 2014 16:27:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-Id: <20140321162740.41cae3d7de8205d23f5ff029@linux-foundation.org>
In-Reply-To: <20140322002159.e1428d6a58899b38b379733c@skynet.be>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
	<20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
	<20140322002159.e1428d6a58899b38b379733c@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014 00:21:59 +0100 Fabian Frederick <fabf@skynet.be> wrote:

> > What we should do is to fix all these call sites so they can handle
> > memory exhaustion.  That's hard so in the interim they should be using
> > __GFP_NOFAIL.
> > 
> 
> Ok, if even ext4 comments are wrong, things gonna be very difficult :)
> Any sample of a callsite transition done well ?  (git id ?)

grep NOFAIL fs/jbd/*.c
