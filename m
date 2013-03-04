Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab3CDDuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:50:19 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47241 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3CDDuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:50:14 -0500
Date: Sun, 03 Mar 2013 21:50:10 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: For review: pid_namespaces(7) man page
To: mtk.manpages@gmail.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	<1362110504.15531.4@driftwood>
	<CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
In-Reply-To: <CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
	(from mtk.manpages@gmail.com on Fri Mar  1 03:57:40 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362369010.29250.3@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 03:57:40 AM, Michael Kerrisk (man-pages) wrote:
> > And yet the glibc guys insist on #define  
> GNU_GNU_GNU_ALL_HAIL_STALLMAN in
> > order to access this Linux-specific feature which has nothing  
> whatsoever to
> > do with the FSF.
> 
> This is a misunderstanding. _GNU_SOURCE is the standard way to expose
> Linux-specific functionality from POSIX header files.

What standard? The Linux kernel is not, and never was, part of the GNU  
project.

Rob