Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbbAIXF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:05:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbbAIXF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:05:27 -0500
Date: Fri, 9 Jan 2015 15:05:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>
Subject: Re: [PATCH char-misc-next 02/13] misc: mic: SCIF ring buffer
 infrastructure
Message-ID: <20150109230526.GB3614@kroah.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
 <6a99cdd6459ca70802f0000c1904bfdb8f45b73b.1418237176.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a99cdd6459ca70802f0000c1904bfdb8f45b73b.1418237176.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:47:42AM -0800, Sudeep Dutt wrote:
> SCIF ring buffer is a single producer, single consumer byte stream ring
> buffer optimized for avoiding reads across the PCIe bus. The ring buffer is
> used to implement a receive queue for SCIF driver messaging between nodes and
> for byte stream messaging between SCIF endpoints. Each SCIF node has a
> receive queue for every other SCIF node, and each connected endpoint has a
> receive queue for messages from its peer. This pair of receive queues is
> referred to as a SCIF queue pair.

And the reason you aren't using the built-in kernel ring buffer code is
why?

You need to document that really well here, or use the in-kernel code
please.

thanks,

greg k-h
