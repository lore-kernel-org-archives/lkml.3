Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaETDTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:19:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaETDTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:19:41 -0400
Date: Tue, 20 May 2014 12:19:38 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, felipe.franciosi@citrix.com,
        roger.pau@citrix.com, jerry.snitselaar@oracle.com, axboe@kernel.dk
Subject: Re: Backport request to stable of two performance related fixes for
 xen-blkfront (3.13 fixes to earlier trees)
Message-ID: <20140520031938.GA30126@kroah.com>
References: <20140514191122.GA7659@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514191122.GA7659@phenom.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg
> 
> This email is in regards to backporting two patches to stable that
> fall under the 'performance' rule:
> 
>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
> 
> I've copied Jerry - the maintainer of the Oracle's kernel. I don't have
> the emails of the other distros maintainers but the bugs associated with it are:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1096909
> (RHEL7)
> https://bugs.launchpad.net/ubuntu/+bug/1319003
> (Ubuntu 13.10)
> 
> The following distros are affected:
> 
> (x) Ubuntu 13.04 and derivatives (3.8)
> (v) Ubuntu 13.10 and derivatives (3.11), supported until 2014-07
> (x) Fedora 17 (3.8 and 3.9 in updates)
> (x) Fedora 18 (3.8, 3.9, 3.10, 3.11 in updates)
> (v) Fedora 19 (3.9; 3.10, 3.11, 3.12 in updates; fixed with latest update to 3.13), supported until TBA
> (v) Fedora 20 (3.11; 3.12 in updates; fixed with latest update to 3.13), supported until TBA
> (v) RHEL 7 and derivatives (3.10), expected to be supported until about 2025
> (v) openSUSE 13.1 (3.11), expected to be supported until at least 2016-08
> (v) SLES 12 (3.12), expected to be supported until about 2024
> (v) Mageia 3 (3.8), supported until 2014-11-19
> (v) Mageia 4 (3.12), supported until 2015-08-01
> (v) Oracle Enterprise Linux with Unbreakable Enterprise Kernel Release 3 (3.8), supported until TBA
> 
> Here is the analysis of the problem and what was put in the RHEL7 bug.
> The Oracle bug does not exist (as I just backport them in the kernel and
> send a GIT PULL to Jerry) - but if you would like I can certainly furnish
> you with one (it would be identical to what is mentioned below).
> 
> If you are OK with the backport, I am volunteering Roger and Felipe to assist
> in jamming^H^H^H^Hbackporting the patches into earlier kernels.

Sure, can you provide backported patches?  As-is, they don't apply to
the 3.10-stable kernel.

thanks,

greg k-h
