Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab3GMSRK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:17:10 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62951 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab3GMSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:17:08 -0400
Message-ID: <1373739421.2002.2.camel@ThinkPad-X230.localdomain>
Subject: Re: [REGRESSION] "UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()" breaks macbook efi boot
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: "Fleming, Matt" <matt.fleming@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dave Young <dyoung@redhat.com>
Date: Sat, 13 Jul 2013 22:17:01 +0400
In-Reply-To: <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
References: <51DD46AD.2010800@canonical.com>
	 <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 12:39 +0100, Fleming, Matt wrote:
> On 10 July 2013 12:34, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
> > Hey,
> >
> > It seems that in the merge window my macbook pro stopped working at some point. I looked for suspicious
> > efi related commits, and found that reverting commit 1acba98f810a14b1255e34bc620594f83de37e36 worked,
> > letting my macbook pro boot succesfully.
> 
> Thanks for the report. I'm going to queue up a revert of this patch,
> Dave Young also reported a problem on his thinkpad.
> 
> > Is there anything I can do to help diagnose this issue?
> 
> Matthew?
Revert this commit fixes my problem on ThinkPad X230 too. Wait Linus
https://lkml.org/lkml/2013/7/13/65 .
-- 
Igor Gnatenko
Fedora release 19 (Schrödinger’s Cat)
Linux 3.9.9-302.fc19.x86_64

