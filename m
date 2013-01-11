Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3AKHeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:34:24 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41001 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401Ab3AKHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:34:22 -0500
Message-ID: <1357889656.3065.2.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Fri, 11 Jan 2013 07:34:16 +0000
In-Reply-To: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
References: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 12:03 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/ipr.c:9138:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ipr_enable_msix'
> drivers/scsi/ipr.c:9165:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ipr_enable_msi'
> drivers/scsi/ipr.c:9188:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'name_msi_vectors'
> drivers/scsi/ipr.c:9200:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ipr_request_other_msi_irqs'
> drivers/scsi/ipr.c: In function 'ipr_probe_ioa':
> drivers/scsi/ipr.c:9422:4: error: implicit declaration of function 'ipr_enable_msix' [-Werror=implicit-function-declaration]
> drivers/scsi/ipr.c:9425:4: error: implicit declaration of function 'ipr_enable_msi' [-Werror=implicit-function-declaration]
> drivers/scsi/ipr.c:9517:3: error: implicit declaration of function 'name_msi_vectors' [-Werror=implicit-function-declaration]
> drivers/scsi/ipr.c:9523:4: error: implicit declaration of function 'ipr_request_other_msi_irqs' [-Werror=implicit-function-declaration]

OK, fine, I'll drop all the ipr patches.  I've been waiting for a month
for them to fix the smatch and sparse warnings.  Please resend the
series with all the fixes.

Thanks,

James


