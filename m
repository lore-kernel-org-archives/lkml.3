Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936193Ab3DKPQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:16:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935525Ab3DKPQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:16:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5166D1BB.3070101@mev.co.uk>
References: <5166D1BB.3070101@mev.co.uk> <20130411132739.32763.82609.stgit@warthog.procyon.org.uk> <20130411132819.32763.72806.stgit@warthog.procyon.org.uk>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: dhowells@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Schleef <ds@schleef.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 05/26] comedi: Don't use create_proc_read_entry() [RFC]
Date: Thu, 11 Apr 2013 16:15:52 +0100
Message-ID: <23048.1365693352@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Abbott <abbotti@mev.co.uk> wrote:

> > Don't use create_proc_read_entry() as that is deprecated, but rather use
> > proc_create_data() and seq_file instead.
> 
> It seems to work okay and is simpler than I thought it would be!  You changed
> the mode of the file to 0644 for some reason though.  Please change it back to
> 0444 or S_IFREG | S_IRUGO.  Thanks.

Ah... cut'n'paste error.  Sorry about that.

David
