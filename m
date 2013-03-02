Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3CBALE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:11:04 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48320 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3CBALC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:11:02 -0500
Date: Sat, 2 Mar 2013 01:11:03 +0100
From: Marcin Jurkowski <marcin1j@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Sven Geggus <lists@fuchsschwanzdomain.de>, linux-kernel@vger.kernel.org
Subject: Re:  Re: reproducible w1 oops on recent kernels (at least since
 3.2.x)
Message-ID: <20130302001103.GB18026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116141627.GA23638@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 16, 2013 3:16:38 PM UTC+1, Evgeniy Polyakov wrote:
> Can you confirm that bug still persists and that it doesn't exist in
> 
> 3.1? Do you have a possibility to bisect w1 bits down to broken
> commit?

Hi

I can confirm that this bug persists in recent kernel. Onewire netlink
interface to W1_SEARCH command must have been broken for a while.

Good news is that it seems to be easy to fix. I'll post an explanation 
and a patch tomorrow.


Regards
