Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbaBDXla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:41:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaBDXl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:41:27 -0500
Date: Tue, 4 Feb 2014 15:42:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gong Chen <gong.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3.12 010/133] x86: Add check for number of available
 vectors before CPU down
Message-ID: <20140204234234.GA31544@kroah.com>
References: <20140204210737.008598235@linuxfoundation.org>
 <20140204210737.312279605@linuxfoundation.org>
 <52F16DD3.9090302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F16DD3.9090302@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 05:46:43PM -0500, Prarit Bhargava wrote:
> 
> 
> On 02/04/2014 04:06 PM, Greg Kroah-Hartman wrote:
> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Prarit Bhargava <prarit@redhat.com>
> > 
> > commit da6139e49c7cb0f4251265cb5243b8d220adb48d upstream.
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64791
> > 
> 
> Greg, there is a follow up to this patch that removes declarations from the
> stack and makes them global within the file.  This was done to avoid a
> -Wframe-larger-than warning that was found in with 0day kernel build service,
> kbuild.
> 
> So I don't think this should go into -stable yet.  I've pushed a patch onto
> LKML to resolve the kbuild warning, and hopefully on the x86 maintainers pick
> it up.

Ok, I've dropped it from the 3.10, 3.12, and 3.13-stable queues.  Please
let stable@kernel.org know when the fix is in Linus's tree, so that
this, and the fix, can be added to the stable trees.

thanks,

greg k-h
