Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3DFRJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 13:09:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56078 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3DFRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 13:09:54 -0400
Date: Sat, 6 Apr 2013 18:09:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130406170952.GK4068@ZenIV.linux.org.uk>
References: <20130406165600.GA29660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406165600.GA29660@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 09:56:00AM -0700, Greg KH wrote:
> From: Kay Sievers <kay@vrfy.org>
> 
> Some drivers want to tell userspace what uid and gid should be used for
> their device nodes, so allow that information to percolate through the
> driver core to userspace in order to make this happen.  This means that
> some systems (i.e.  Android and friends) will not need to even run a
> udev-like daemon for their device node manager and can just rely in
> devtmpfs fully, reducing their footprint even more.

Excuse me, but "some drivers" have no fucking business to mess with
uid and gid assignments in the first place...
