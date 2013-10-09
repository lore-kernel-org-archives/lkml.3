Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3JIU42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:56:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3JIU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:56:27 -0400
Date: Wed, 9 Oct 2013 13:57:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [Trivial -next PATCH] treewide: devm_kzalloc: Remove unnecessary
 OOM messages
Message-ID: <20131009205704.GA23576@kroah.com>
References: <1381351922.2050.22.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381351922.2050.22.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 01:52:02PM -0700, Joe Perches wrote:
> There is no need to have OOM error messages after
> devm_kzalloc failures as the call already does a
> dump_stack() on OOM.
> 
> This removal reduces overall object code size a small
> amount and overall code size by ~1000 lines.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
