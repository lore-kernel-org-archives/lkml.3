Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbaGRHl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:41:59 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:56939 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaGRHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:41:57 -0400
Date: Fri, 18 Jul 2014 09:41:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Sparc Allmodconfig Fails
Message-ID: <20140718074143.GB20028@ravnborg.org>
References: <CAPDOMViDWF93xDQ=OYWFEu=9ih6cwcEKv4P+nOihcnRrDXiAww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMViDWF93xDQ=OYWFEu=9ih6cwcEKv4P+nOihcnRrDXiAww@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:21:04AM -0400, Nick Krause wrote:
> The build for sparc allmodconfig is still failing for the main branch
> of the linux kernel.
> I would recommend fixing these issues. I am attaching my build
> warnings and errors
> logs for the failing build test I did today.

Did you actually look into the log yourself?

This should give you a hint:

make[1]: *** No rule to make target `/media/nick/Nick's', needed by
+`kernel/x509_certificate_list'.  Stop.


All the rest are random warnings that may or may not be specific for sparc64.

	Sam
