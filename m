Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbbAWDaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:30:19 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:37228 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbbAWDaQ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 22 Jan 2015 22:30:16 -0500
Message-ID: <1421983803.24914.3.camel@stgolabs.net>
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused
 by semop()
From: Davidlohr Bueso <dave@stgolabs.net>
To: ethan zhao <ethan.zhao@oracle.com>
Cc: Stephen Smalley <stephen.smalley@gmail.com>,
        Ethan Zhao <ethan.kernel@gmail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Eric Paris <eparis@parisplace.org>, Paul Moore <paul@paul-moore.com>,
        selinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ethan.kernel@gmail.conm
Date: Thu, 22 Jan 2015 19:30:03 -0800
In-Reply-To: <54C1AFA2.8040900@oracle.com>
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com>
	 <54BE61F0.202@tycho.nsa.gov>
	 <CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com>
	 <54BF3971.2090003@colorfullife.com>
	 <CABawtvO3PdKhmeH_H1v_tQxmgOBQrnLGNayTE1=EbcxJbtwAzQ@mail.gmail.com>
	 <CAB9W1A3kabX9qMm56k=FJ1jcL8ou4APqt8teT38oFCiu=g1wNg@mail.gmail.com>
	 <54C1AFA2.8040900@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 10:19 +0800, ethan zhao wrote:
> >   If not, what kernel
> > version were you running when you triggered the bug?
>   To be honest, a kernel from distro, but not released, but before we 
> get it clear, we wouldn't public more.

Sheesh, could Oracle be any more (ridiculously) secretive about what the
hell kernel(s) they run... it's like pulling teeth. *sigh*

