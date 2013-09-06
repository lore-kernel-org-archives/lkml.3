Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab3IFBfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:35:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab3IFBfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:35:05 -0400
Date: Thu, 5 Sep 2013 21:34:55 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906013455.GA10073@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130906011924.GA7970@redhat.com>
 <20130905212834.605408a4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905212834.605408a4@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:28:34PM -0400, Steven Rostedt wrote:
 > On Thu, 5 Sep 2013 21:19:24 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > For whatever dumb reason, when running 'make install' on a Fedora system,
 > > os-prober tries to figure out what filesystems are needed by loading filesystems,
 > > and seeing what sticks..  Today it blew up spectacularly when it got to
 > > loading reiserfs..  System wedged entirely afterwards.
 > 
 > Could it be that the reiserfs module was compiled differently than the
 > running kernel?
 
ohhhh... it was probably installing the just-built version over the same '3.11+'
modules tree that was running.  This has never been a problem before though..

	Dave
 
