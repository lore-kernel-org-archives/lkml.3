Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab3CHWuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:50:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359Ab3CHWui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:50:38 -0500
Date: Fri, 8 Mar 2013 17:49:50 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
Message-ID: <20130308224950.GM13719@hansolo.jdub.homelinux.org>
References: <20130307185642.GF13719@hansolo.jdub.homelinux.org>
 <5138E56B.6090308@suse.cz>
 <20130307191005.GH13719@hansolo.jdub.homelinux.org>
 <20130307211426.GI13719@hansolo.jdub.homelinux.org>
 <20130307231242.GC4280@kroah.com>
 <20130308010140.GJ13719@hansolo.jdub.homelinux.org>
 <20130308013923.GA12474@kroah.com>
 <20130308212722.GL13719@hansolo.jdub.homelinux.org>
 <513A6A65.9050706@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A6A65.9050706@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 11:47:01PM +0100, Jiri Slaby wrote:
> Yeah, I agree this is ugly. Just re-definining MODULE_PARAM_PREFIX at
> the end of the file should do the trick (followed by
> "module_param(nr_uarts, uint, 0644)").

For some reason, I thought I had tried that.  Maybe I didn't.  I'll look
into it again.

> >  module_param(skip_txen_test, uint, 0644);
> >  MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");
> 
> Well, we should do that for all the parameters, right? Sigh.

Yeah.

josh
