Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3APV4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:56:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849Ab3APV4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:56:00 -0500
Date: Wed, 16 Jan 2013 16:55:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        Ryan Ware <ryan.r.ware@intel.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130116215551.GB4222@redhat.com>
References: <20130116144836.GB29845@redhat.com>
 <1358350391.4593.112.camel@falcor1>
 <20130116155406.GC29845@redhat.com>
 <1358357079.4593.135.camel@falcor1>
 <20130116182146.GE29845@redhat.com>
 <1358361912.4593.162.camel@falcor1>
 <20130116185741.GA3038@redhat.com>
 <1358365044.4593.186.camel@falcor1>
 <20130116194759.GA4502@redhat.com>
 <1358367957.4593.198.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358367957.4593.198.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 03:25:57PM -0500, Mimi Zohar wrote:

[..]
> > So irrespective of fact how RPM does it. What are basic commands/steps to
> > generate signature of a file and how to store it later in an extended
> > attribute?
> 
> evmctl calculates and writes out the 'security.evm' and 'security.ima'
> extended attribute.  The ima-evm-utils package README contains some
> directions for getting started.  We should probably move this thread to
> the linux-ima-user mailing list.

Ok, I will go through README file. I think we should still keep this
thread on lkml as it is not yet clear whether IMA is sufficient for
this requirement or not.

Thanks
Vivek
