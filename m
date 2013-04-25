Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab3DYWoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:44:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746Ab3DYWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:43:59 -0400
Date: Thu, 25 Apr 2013 15:43:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        David Sterba <dsterba@suse.cz>, Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 4/5] x86: Add support for LZ4-compressed kernel
Message-Id: <20130425154356.4498719b15ccff41aaec0762@linux-foundation.org>
In-Reply-To: <20130306063738.GB4979@Corona>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
	<1362484056-9778-5-git-send-email-kyungsik.lee@lge.com>
	<18eb6ca7-6993-40e9-a58d-116e1f6c37f6@email.android.com>
	<20130306063738.GB4979@Corona>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013 15:37:38 +0900 Kyungsik Lee <kyungsik.lee@lge.com> wrote:

> On Tue, Mar 05, 2013 at 08:13:38AM -0800, H. Peter Anvin wrote:
> > Please add the new magic to Documentation/x86/boot.txt as well.
> 
> Ok, I will update it as soon as the patch set is stabilized.

It's been six weeks.  Please send the update asap.
