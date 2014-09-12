Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaILQAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:00:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbaILQAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:00:13 -0400
Date: Fri, 12 Sep 2014 11:59:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Thomas D." <whissi@whissi.de>
Cc: Baoquan He <bhe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: [Patch v3 1/2] kaslr: check if kernel location is changed
Message-ID: <20140912155940.GD32421@redhat.com>
References: <1410502832-3573-1-git-send-email-bhe@redhat.com>
 <20140912152244.GA2781@dhcp-16-105.nay.redhat.com>
 <20140912153308.GB4408@redhat.com>
 <5413179C.8020902@whissi.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5413179C.8020902@whissi.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 05:56:12PM +0200, Thomas D. wrote:
> Hi,
> 
> Vivek Goyal wrote:
> > You had reported kexec issues with CONFIG_RANDOMIZE_BASE=y. Does this
> > patch resolve the issue for you?
> 
> Yup! Tested against kernel-3.16.2.

Thanks. Given this patch is small and should not break anything else, I
think it might make sense to send it to stable too.

Thanks
Vivek
