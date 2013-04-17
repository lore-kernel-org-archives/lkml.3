Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3DQBAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:00:38 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:53132 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3DQBAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:00:36 -0400
Date: Tue, 16 Apr 2013 18:00:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jerry Chuang <jerry-chuang@realtek.com>,
        linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/28] rtl8192u: Don't need to save device proc dir PDE
 [RFC]
Message-ID: <20130417010029.GE11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182639.27773.60503.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416182639.27773.60503.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:26:39PM +0100, David Howells wrote:
> Don't need to save the PDE of a directory created under /proc/net/rtl8192/ as
> we can use proc subtree deletion to get rid of it and all its children.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jerry Chuang <jerry-chuang@realtek.com>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> cc: linux-wireless@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
