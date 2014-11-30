Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaK3OTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 09:19:15 -0500
Received: from mout.gmx.net ([212.227.15.19]:63355 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaK3OTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 09:19:14 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Scot Doyle <lkml14@scotdoyle.com>
Subject: Re: [PATCH v10] tpm_tis: verify interrupt during init
Date: Sun, 30 Nov 2014 15:24:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.2; KDE/4.12.5; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Michael Mullin <masmullin@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
References: <20140908220238.GB6204@obsidianresearch.com> <alpine.DEB.2.11.1409242234220.2311@localhost.localdomain> <20140929172457.GC15607@obsidianresearch.com>
In-Reply-To: <20140929172457.GC15607@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201411301524.11327.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:a+PpV7sy8LagLCiu6JlbBAhj+Ym5GbJer8I6OFafQ+ndh85TZkH
 3Z6nzNW/AYlTtmJZOftIwwEN+VN0ZkfAZY3BDSUuIuLXs08LdQ2yGGgeK8hr8TW3Fdg432O
 4qFeVvxcwg3rjwNePmiC9teNvexGZHpjI/RDA6jX1WkqH9drwvhVCwr0+Fga5YXckWFmNIK
 LVNjVEpXkCQSq7kjjDR7Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scot,

Am Montag, 29. September 2014, 19:24:57 schrieb Jason Gunthorpe:
> On Wed, Sep 24, 2014 at 10:41:10PM +0000, Scot Doyle wrote:
> > Some machines, such as the Acer C720 and Toshiba CB35, have TPMs that do
> > not send IRQs while also having an ACPI TPM entry indicating that they
> > will be sent. These machines freeze on resume while the tpm_tis module
> > waits for an IRQ, eventually timing out.
> > 
> > When in interrupt mode, the tpm_tis module should receive an IRQ during
> > module init. Fall back to polling mode if none is received when expected.
> > 
> > Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> > Tested-by: Michael Mullin <masmullin@gmail.com>
> 
> Looks good with enable fixed
> 
> Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>


Applied to my tree:
https://github.com/PeterHuewe/linux-tpmdd for-james

Will be included in the next pull-request.

Thanks,
Peter
