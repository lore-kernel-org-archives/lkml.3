Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaKTOcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:32:03 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:53945 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKTOcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:32:00 -0500
Date: Thu, 20 Nov 2014 18:33:05 +0400
From: Antony Pavlov <antonynpavlov@gmail.com>
To: Mason <mpeg.blue@free.fr>
Cc: Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Looking for good references for ARM driver development
Message-Id: <20141120183305.53af4ec99d746403b339aaf1@gmail.com>
In-Reply-To: <546CBFAC.9040906@free.fr>
References: <546C920A.7060800@free.fr>
	<546CB0EB.9080005@suse.de>
	<546CBFAC.9040906@free.fr>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 17:05:00 +0100
Mason <mpeg.blue@free.fr> wrote:

> Hello Andreas,
> 
> On 19/11/2014 16:02, Andreas Färber wrote:
> 
> > Am 19.11.2014 um 13:50 schrieb Mason:
> >
...
> > Since this appears to be about an ARM SoC according to your To list,
> > in general, you create a device tree binding, that binding is
> > registered within your platform/... driver code and referenced in the
> > device tree for SoC or board, and then your driver will automatically
> > be probed.
> 
> I know nothing about DT (aside from the Wikipedia entry).
> I'll take a closer look at Documentation/devicetree.
> Will that explain what platform/... is?
> 
> I see a drivers/platform folder, but nothing ARM-specific there?

There are very good presentations from Free Electrons:

  * http://free-electrons.com/pub/conferences/2013/elce/petazzoni-device-tree-dummies/petazzoni-device-tree-dummies.pdf
     ** see also http://www.youtube.com/watch?v=m_NyYEBxfn8
  * https://archive.fosdem.org/2013/schedule/event/arm_in_the_linux_kernel/attachments/slides/273/export/events/attachments/arm_in_the_linux_kernel/slides/273/arm_support_kernel.pdf

-- 
Best regards,
  Antony Pavlov
