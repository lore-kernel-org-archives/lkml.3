Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaBYSoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:44:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbaBYSoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:44:13 -0500
Date: Tue, 25 Feb 2014 13:43:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140225184342.GF2701@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
 <530CE320.6000808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530CE320.6000808@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 10:38:24AM -0800, H. Peter Anvin wrote:
> On 01/27/2014 10:57 AM, Vivek Goyal wrote:
> > This is loader specific code which can load bzImage and set it up for
> > 64bit entry. This does not take care of 32bit entry or real mode entry
> > yet.
> 
> Is there any use in that?  Real mode entry especially is more than a bit
> scary when coming from another kernel already...

I think 64bit entry should be good for x86_64. When we start supporting
this new system call on x86(32bit), then we can implement 32bit entry 
support (which should not be hard).

I have no plans to implement 16bit entry support. I just wanted to mention
explicitly what is currently supported.

Thanks
Vivek
