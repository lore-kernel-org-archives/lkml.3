Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3JKPsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:48:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43695 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab3JKPse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:48:34 -0400
Date: Fri, 11 Oct 2013 16:48:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, hpa@linux.intel.com, keescook@chromium.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, jbeulich@suse.com, keir@xen.org,
        xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011154805.GB30181@srcf.ucam.org>
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
 <877gdkce6s.fsf@tw-ebiederman.twitter.com>
 <20131011110455.GA3626@debian70-amd64.local.net-space.pl>
 <20131011125206.GA2772@redhat.com>
 <20131011153727.GA30181@srcf.ucam.org>
 <20131011154450.GB2772@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011154450.GB2772@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 11:44:50AM -0400, Vivek Goyal wrote:

> Just Curious. How is it useful. IOW, what's your use case of booting a new
> kernel and then jumping back.

I'm kexecing into a kernel with a modified /dev/mem, modifying the 
original kernel and then jumping back into it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
