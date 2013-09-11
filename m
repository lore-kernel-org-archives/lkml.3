Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3IKNoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab3IKNog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:44:36 -0400
Date: Wed, 11 Sep 2013 09:44:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        ebiederm@xmission.com, hpa@zytor.com, matthew.garrett@nebula.com
Subject: Re: [PATCH 14/16] kexec: Export sysfs attributes for secureboot and
 secure modules to user space
Message-ID: <20130911134401.GA15364@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-15-git-send-email-vgoyal@redhat.com>
 <20130910224009.GA23727@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910224009.GA23727@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 03:40:09PM -0700, Greg KH wrote:
> On Tue, Sep 10, 2013 at 05:44:29PM -0400, Vivek Goyal wrote:
> > User space kexec-tools need to know whether to verify signature of kernel
> > image being loaded. This patch exports two knobs to user space. One is
> > for knowing if  secureboot is enabled, this knob will be set to 1 if secure
> > boot is enabled. Other knob is secure_module_enabled. This knob will be set
> > to 1 if secure modules is one.
> > 
> > kexec-tools will verify signature of kernel image if either secureboot is
> > enabled or secure modules is enabled. The only difference between two is
> > that kexec-tools will set secureboot on in bootparams being passed to
> > second kernel if secureboot is on in first kernel.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  kernel/ksysfs.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> 
> Minor nit, if you add/modify/delete sysfs files, you also have to update
> Documentation/ABI/ with the information about those files.
> 

Sure. Will update Documentation/ABI/ in next version.

Thanks
Vivek
