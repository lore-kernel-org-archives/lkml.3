Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaBTXBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:01:32 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34041 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751862AbaBTXBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:01:30 -0500
Date: Thu, 20 Feb 2014 17:01:26 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: minyard@acm.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, rja@sgi.com
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220230126.GA13558@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:28:29AM -0500, Matthew Garrett wrote:
> The ACPI IPMI driver implements IPMI operation region support for the ACPI
> core. Systems that declare ACPI operation regions may reference them at any
> time, including during kernel initialisation. These accesses will fail
> unless the ACPI IPMI driver is present, and undesirable system behaviour
> may result. 

Could you be more specific?  Is the problem kernel code
trying to use IPMI functionality before the ipmi_si driver
is loaded?  Or something else?

What is the "undesirable system behaviour"?


> Set the default to Y in order to encourage distributions and
> users to configure kernels to avoid awkward surprises.

What are the "awkward surprises"?

Thanks,
-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
