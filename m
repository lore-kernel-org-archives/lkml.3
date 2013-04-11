Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416Ab3DKWe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:34:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760767Ab3DKWeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:34:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130411190728.GC32045@kroah.com>
References: <20130411190728.GC32045@kroah.com> <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/26] Eliminate create_proc_read_entry() [RFC]
Date: Thu, 11 Apr 2013 23:34:21 +0100
Message-ID: <19749.1365719661@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> The ones I've been cc:ed on, with the exception of the hostap patch, I
> will be glad to take though my trees now, unless you want to take them
> yourself?

If Al is happy with it, he might want to take it through his tree since it's
sat on top of his experimental branch - especially since the last patch is
dependent on all the intermediate steps.

David
