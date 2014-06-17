Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbaFQLw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:52:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42139 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbaFQLw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:52:26 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Tue, 17 Jun 2014 12:52:22 +0100
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v4 6/7] thermal: add trace events to the power
 allocator governor
Message-ID: <20140617115222.GC2801@e104805>
References: <1402996493-3578-1-git-send-email-javi.merino@arm.com>
 <1402996493-3578-7-git-send-email-javi.merino@arm.com>
 <20140617071838.1b0d8673@gandalf.local.home>
MIME-Version: 1.0
In-Reply-To: <20140617071838.1b0d8673@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 17 Jun 2014 11:52:16.0116 (UTC) FILETIME=[95A4CB40:01CF8A22]
X-MC-Unique: 114061712522403601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:18:38PM +0100, Steven Rostedt wrote:
> On Tue, 17 Jun 2014 10:14:52 +0100
> "Javi Merino" <javi.merino@arm.com> wrote:
> 
> > Add trace events for the power allocator governor and the power actor
> > interface of the cpu cooling device.
> > 
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Eduardo Valentin <edubezval@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > 
> > ---
> > 
> > trace-cmd needs the patched attached in
> > http://article.gmane.org/gmane.linux.kernel/1704423 for this to work.
> 
> The recently released trace-cmd v2.4 contains this.

Good to know, I'll drop the text from future uploads.  Thanks!
Javi

