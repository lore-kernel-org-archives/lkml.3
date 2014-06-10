Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaFJU3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:29:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaFJU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:29:18 -0400
Date: Tue, 10 Jun 2014 13:33:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] debugfs: Fix corrupted loop in
 debugfs_remove_recursive
Message-ID: <20140610203307.GA21000@kroah.com>
References: <20140609140607.3e3aae39@gandalf.local.home>
 <20140610093357.7ef3792b@gandalf.local.home>
 <20140610202302.GB20499@kroah.com>
 <20140610162256.7a29771b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610162256.7a29771b@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:22:56PM -0400, Steven Rostedt wrote:
> On Tue, 10 Jun 2014 13:23:02 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> 
> > > Note, the tests expect debugfs to be mounted at /debug.
> > 
> > Well, those are some broken tests :)
> 
> And that's part of the reason why I haven't pushed them to be included
> in mainline's tools/testing/ directory.

It should be simple to change that...
