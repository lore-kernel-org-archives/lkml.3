Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaIXSe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:34:58 -0400
Received: from mout.gmx.net ([212.227.15.18]:55030 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbaIXSe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:34:56 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Date: Wed, 24 Sep 2014 20:36:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.2-dirty; KDE/4.12.5; x86_64; ; )
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com> <20140924171338.GG8898@obsidianresearch.com>
In-Reply-To: <20140924171338.GG8898@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409242036.07859.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:258E4vzEUGY77v8UMeKQ11nP5TPcWuHDL4u1RaIHkD7EKAf8kZA
 O5XrY4bDI0JtLKIJUg9s2wKZf8kXB1lcOtSFTUzL6rawc0vCPDQRcn9nb1V66Tu6FRs+sdu
 R29dG10M/nKZz4E4BfTyfeLM+U6quWg1JNDxoIqtrFwTxp71Kv+uNAwsfIpK/9wum+53G9y
 0Ewt1cX1/6gJUkmPYZ3zQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. September 2014, 19:13:38 schrieb Jason Gunthorpe:
> On Wed, Sep 24, 2014 at 12:06:02PM +0300, Jarkko Sakkinen wrote:
> > Added tpm2-sysfs.c that implements sysfs attributes for a TPM2
> > device.
> 
> You need to document in Documentation every new sysfs that is added.
> 
> The existing ones are not documented :(

For 1.2 - they are.
Documentation/ABI/stable/sysfs-class-tpm
So we also now what our stable sysfs abi is :)



Peter

