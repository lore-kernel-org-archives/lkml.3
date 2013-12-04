Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab3LDRD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:03:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3LDRD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:03:27 -0500
Date: Wed, 4 Dec 2013 09:03:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 000/212] 3.12.3-stable review
Message-ID: <20131204170326.GC14367@kroah.com>
References: <20131202191248.517975703@linuxfoundation.org>
 <529E52D9.4080103@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529E52D9.4080103@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:53:29PM -0700, Shuah Khan wrote:
> On 12/02/2013 12:13 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.12.3 release.
> >There are 212 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Wed Dec  4 19:11:18 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.3-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Patch applied with warnings:
> 
>  git apply --index ../stable_tree_project/patch-3.12.3-rc1
> ../stable_tree_project/patch-3.12.3-rc1:8684: space before tab in
> indent. * Anon maps don't have the execname.
> ../stable_tree_project/patch-3.12.3-rc1:8685: space before tab in
> indent. */ warning: 2 lines add whitespace errors.
> 
> Problem patch:
> 
> Don Zickus <dzickus@redhat.com> perf tools: Synthesize anon MMAP
> records again
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1311.1/03602.html

Yeah, I took the upstream version directly, whitespace issues and all :)

thanks for testing this, and the other 2 kernels, and letting me know.

greg k-h
