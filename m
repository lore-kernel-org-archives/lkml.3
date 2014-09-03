Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaICUIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:08:16 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56908 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaICUIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:08:15 -0400
Date: Wed, 3 Sep 2014 13:08:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Prarit Bhargava <prarit@redhat.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
Message-ID: <20140903200811.GB7240@roeck-us.net>
References: <1409695097-5831-1-git-send-email-prarit@redhat.com>
 <1598720.9R5g9ohVoY@petert>
 <54075663.8090204@redhat.com>
 <2934553.BlOlR0jvHm@petert>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2934553.BlOlR0jvHm@petert>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:13:55PM -0500, Peter Tyser wrote:
> > > Can you give more background on your hardware and firmware setup?
> > 
> > Unfortunately I cannot :(  The system isn't "mine" per se.  It is (as the
> > dumps show) IBM's.
> 
> Can you look at the IBM manual and see info about which chipsets are used, and 
> how they are connected?
> 
> > Are there
> > 
> > > physically two ICH bridges, or just one that is showing up two times due
> > > to a firmware bug?
> > 
> > I can answer that.  There are two physical ICH bridges, and according to
> > Intel one should be masked off.  We shouldn't run with two.
> 
> Interesting.  The "normal" setup I'm familiar with is multiple CPUs wired up 
> to one IOH, and that IOH would be wired up to the ICH10.  There'd only be one 
> ICH10 in this configuration though.  An example is on page 30 of 
> http://www.intel.com/content/dam/www/public/us/en/documents/datasheets/5520-5500-chipset-ioh-datasheet.pdf  I'm not sure how it'd be possible to wire up 2 
> ICH10s to one CPU?
> 
Multiple ICHs connected to multiple CPUs, maybe ?

Guenter
