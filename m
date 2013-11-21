Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3KUTTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:19:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35692 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3KUTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:19:11 -0500
Date: Thu, 21 Nov 2013 19:19:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131121191907.GA26366@srcf.ucam.org>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131121190350.GC17070@kroah.com>
 <20131121190620.GA25951@srcf.ucam.org>
 <20131121191305.GK16208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121191305.GK16208@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:13:05PM -0500, Vivek Goyal wrote:
> On Thu, Nov 21, 2013 at 07:06:20PM +0000, Matthew Garrett wrote:
> > That would require a certain degree of massaging from userspace if we 
> > want to be able to use the existing Authenticode signatures. Otherwise 
> > we need to sign kernels twice.
> 
> I was thinking oof signing the same kernel twice. Can I sign authenticode
> signed kernel again (using RSA signature as we do for modules) and append
> the signature to bzImage. 

No, you'd need to do it the other way around.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
