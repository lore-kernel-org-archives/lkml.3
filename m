Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3LEPmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:42:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab3LEPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:42:33 -0500
Date: Thu, 5 Dec 2013 07:43:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 34/39] vme: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131205154340.GA7460@kroah.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003701ceefb6$64918db0$2db4a910$%han@samsung.com>
 <CAAb+SYZ+891u6xAStg36mFa85YPNnrXJiVZUuQoupk5U+Brx+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAb+SYZ+891u6xAStg36mFa85YPNnrXJiVZUuQoupk5U+Brx+Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:14:37PM +0800, ZHAO Gang wrote:
> On Tue, Dec 3, 2013 at 7:29 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> 
> Greg, this patch should be reverted. It do the opposite things.

Not at all, it is correct.
