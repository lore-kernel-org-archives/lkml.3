Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLEQSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:18:22 -0500
Received: from tex.lwn.net ([70.33.254.29]:44379 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaLEQSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:18:21 -0500
Date: Fri, 5 Dec 2014 11:18:18 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Streetman <ddstreet@ieee.org>, Jennings <sjennings@variantweb.net>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: Re: [PATCH linux-next] Documentation: Build mic/mpssd only for
 x86_64
Message-ID: <20141205111818.551a870f@lwn.net>
In-Reply-To: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
References: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Dec 2014 13:27:29 -0800
Ashutosh Dixit <ashutosh.dixit@intel.com> wrote:

> mic/mpssd along with MIC drivers are currently only usable on
> x86_64. So build mic/mpssd only for x86_64 to avoid build breaks on
> big-endian systems.

I can certainly apply this.  But it seems to me that this kind of code
doesn't belong in the documentation directory.  How about a patch to move
it to tools/ ?

jon
