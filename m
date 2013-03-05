Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3CEKZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:25:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60190 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3CEKZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:25:15 -0500
Date: Tue, 5 Mar 2013 11:25:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, htejun@gmail.com,
        ming.lei@canonical.com, sshtylyov@mvista.com, lpechacek@suse.cz,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com, jlee@suse.com, james.d.ralston@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] ata: Fix DVD not dectected at some Haswell platforms
Message-ID: <20130305102513.GA4914@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Youquan Song <youquan.song@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, htejun@gmail.com,
	ming.lei@canonical.com, sshtylyov@mvista.com, lpechacek@suse.cz,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.heasley@intel.com, jlee@suse.com, james.d.ralston@intel.com,
	stable@vger.kernel.org
References: <1361203255-1670-1-git-send-email-youquan.song@intel.com>
 <20130305142114.GA27413@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130305142114.GA27413@linux-youquan.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 09:21:14AM -0500, Youquan Song wrote:
> Hi Maintainer,
> 
> Can you take the patch which is needed by some new platforms?

I think you've got the wrong guy. Here's how you can find out who the
maintainer is:

So your patch is against drivers/ata/ata_piix.c. So you do:

$ ./scripts/get_maintainer.pl -f drivers/ata/ata_piix.c
Jeff Garzik <jgarzik@pobox.com> (supporter:SERIAL ATA (SATA)...)
linux-ide@vger.kernel.org (open list:SERIAL ATA (SATA)...)
linux-kernel@vger.kernel.org (open list)

And this is the CC list you can use to send the patch to.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
