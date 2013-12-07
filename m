Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3LGLlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 06:41:53 -0500
Received: from mout.gmx.net ([212.227.17.20]:63061 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab3LGLlv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 06:41:51 -0500
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] char: tpm: nuvoton: remove unused variable
Date: Sat, 7 Dec 2013 12:42:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0; KDE/4.10.5; x86_64; ; )
Cc: Michal Nazarewicz <mpn@google.com>, Dan Morav <dmorav@nuvoton.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1385744418-9516-1-git-send-email-mpn@google.com> <20131129211252.GB25451@obsidianresearch.com>
In-Reply-To: <20131129211252.GB25451@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201312071242.29947.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:aqLExuowDIAVx5z9js+hR2w9C/0pNDtvpjypqQgQGT80qR3zqtL
 QnodcdAC2TjRL04DEqwGCAyckMiWPK3Nest5ReOHFY7O9VugluIMEnF2g98YkKASlKDu4ma
 m+yym7qIstc9DqRWFgPh4sS+CfhWltdXt4oXY51SpZpAA16tkeu1wQcpgZMWuy5mYybHuTj
 AaIhNGEagJ3yaVmYkzUVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 29. November 2013, 22:12:52 schrieb Jason Gunthorpe:
> On Fri, Nov 29, 2013 at 06:00:18PM +0100, Michal Nazarewicz wrote:
> > From: Michal Nazarewicz <mina86@mina86.com>
> > 
> > “wait” wait queue is defined but never used in the function, thus
> > it can be removed.
> > 
> > Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> > 
> >  drivers/char/tpm/tpm_i2c_nuvoton.c | 1 -
> >  1 file changed, 1 deletion(-)
> 
> Acked-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Thanks,
> Jason


Applied.

https://github.com/PeterHuewe/linux-tpmdd/commits/for-james

Thanks
Peter
