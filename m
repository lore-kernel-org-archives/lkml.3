Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3FGIlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:41:10 -0400
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2244 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3FGIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:41:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2 0/4] media: i2c: ths7303 cleanup
Date: Fri, 7 Jun 2013 10:40:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com> <2855590.yx9zfYZLis@avalon> <CA+V-a8vh-ttz1QQmV59fP5c3vK=1zC5QfmkHc9Du0ZAcY712Dg@mail.gmail.com>
In-Reply-To: <CA+V-a8vh-ttz1QQmV59fP5c3vK=1zC5QfmkHc9Du0ZAcY712Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071040.35174.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 6 2013 12:05:38 Prabhakar Lad wrote:
> Hi Hans,
> 
> On Sun, May 26, 2013 at 6:50 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > On Saturday 25 May 2013 23:09:32 Prabhakar Lad wrote:
> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >>
> >> Trivial cleanup of the driver.
> >>
> >> Changes for v2:
> >> 1: Dropped the asynchronous probing and, OF
> >>    support patches will be handling them independently because of
> >> dependencies. 2: Arranged the patches logically so that git bisect
> >>    succeeds.
> >>
> >> Lad, Prabhakar (4):
> >>   ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
> >>   media: i2c: ths7303: remove init_enable option from pdata
> >>   media: i2c: ths7303: remove unnecessary function ths7303_setup()
> >>   media: i2c: ths7303: make the pdata as a constant pointer
> >>
> Can you pick up this series or do you want me to issue a pull for it ?

I've picked it up. I kept the dm365 patch separate, but I did improve the
commit log a bit.

Regards,

	Hans
