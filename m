Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab3LEPmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:42:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3LEPmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:42:51 -0500
Date: Thu, 5 Dec 2013 07:43:58 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 28/39] staging: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131205154358.GB7460@kroah.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003101ceefb5$dc1b0380$94510a80$%han@samsung.com>
 <CAAb+SYZh1KXHQV0GSeFtOkYC=3acZYRvSnqf-VR2rH=T69nWxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAb+SYZh1KXHQV0GSeFtOkYC=3acZYRvSnqf-VR2rH=T69nWxg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:06:33PM +0800, ZHAO Gang wrote:
> On Tue, Dec 3, 2013 at 7:26 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >
> 
> I think you misunderstood the checkpatch.pl warning, it tells you what
> to do, not what not to do.
> 
> WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> 
> This means use DEFINE_PCI_DEVICE_TABLE to replace struct
> pci_device_id, not reverse.

No, checkpatch is wrong, and is being fixed, this patch is correct.
