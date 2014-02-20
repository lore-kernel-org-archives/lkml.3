Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaBTVtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:49:16 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42941 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947AbaBTVtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:49:14 -0500
Date: Thu, 20 Feb 2014 15:49:13 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220214913.GR17949@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com> <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230> <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392929163.20109.5.camel@x230>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 08:46:04PM +0000, Matthew Garrett wrote:
> On Thu, 2014-02-20 at 14:40 -0600, Russ Anderson wrote:
> 
> > There are any number of reasons why a BMC may not respond.
> > BMCs are notorious for being flakey, with different types
> > of BMCs that may or may not be reliable.  You do not want
> > to make the kernel boot dependent on an unreliable component.
> 
> You appear to be saying "SGI ship hardware that doesn't work. We don't
> know why it doesn't work and we're not interested in fixing it, so we'd
> prefer the default kernel configuration to be broken". That doesn't seem
> like an especially compelling argument.

You appear to not understand the mess this causes.  We have hit
this on 3rd party boards, not just SGI built hardware (much
of which is industry standard components).  It causes problems
both for flakey hardware _and_ functioning hardware.


-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
