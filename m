Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab3EBUPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:15:15 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:21733 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620Ab3EBUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:15:13 -0400
Date: Thu, 2 May 2013 22:15:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: modpost command line still is a problem
Message-ID: <20130502201511.GA17608@merkur.ravnborg.org>
References: <5182A850.5010905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182A850.5010905@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 10:54:24AM -0700, H. Peter Anvin wrote:
> At least as far as current linus, "make allmodconfig" still fails with
> O= in a sufficiently deep directory due to the modpost command line
> being too long.
> 
> There was a bunch of talk about how to address that, but did anything
> ever come of it?

Following patch:
http://marc.info/?l=linux-kbuild&m=136723776203823&w=2

is waiting for Michal to pick it up.
It is on top of the kbuild branck of the kbuild tree (yet to be merged).

	Sam
