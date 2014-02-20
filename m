Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaBTU7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:59:06 -0500
Received: from relay3.sgi.com ([192.48.152.1]:49478 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751796AbaBTU7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:59:04 -0500
Date: Thu, 20 Feb 2014 14:59:02 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220205901.GM17949@sgi.com>
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
> > This is also a problem for systems with functional BMCs.  Our
> > large cluster systems do all IPMI traffic (monitoring) through
> > a system controller back door.  We do not want the kernel
> > doing IPMI commands on those systems.
> 
> Why not?

Because some customers want to use cpu cycles for their
application and let the ipmi monitoring go on through
the system controller network.

-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
