Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaHQJdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 05:33:50 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59382 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaHQJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 05:33:49 -0400
Date: Sun, 17 Aug 2014 12:33:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] headers: remove fs.h from poll.h
Message-ID: <20140817093348.GA25122@p183.telecom.by>
References: <20140816233746.GA32332@p183.telecom.by>
 <CA+55aFw3B=USNMLdehm+hv9fVWE1yaR42a2y8udcE8QvJfbSPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw3B=USNMLdehm+hv9fVWE1yaR42a2y8udcE8QvJfbSPA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 06:41:35PM -0600, Linus Torvalds wrote:
> Doors this actually help anything? fs.h tends to get included other ways
> anyway, and the double inclusion protection means that the compiler doesn't
> even spend extra time on it..
> 
> IOW, I'd like to see "this improves compile times by xyz" or some other
> explanation.

This particular patch doesn't change situation because it is so small and
removes only one header from one file.

I can send bigger patch removing fs.h from many possible places.

	Alexey
