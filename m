Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab3APWJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:09:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3APWJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:09:23 -0500
Date: Wed, 16 Jan 2013 14:09:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 3/4] timer_list: split
 timer_list_show_tickdevices
Message-Id: <20130116140921.c6ccc8bb.akpm@linux-foundation.org>
In-Reply-To: <1358286372-13777-4-git-send-email-nzimmer@sgi.com>
References: <1358286372-13777-1-git-send-email-nzimmer@sgi.com>
	<1358286372-13777-4-git-send-email-nzimmer@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 15:46:11 -0600
Nathan Zimmer <nzimmer@sgi.com> wrote:

> Split timer_list_show_tickdevices out the header and just pull the rest up
> to timer_list_show.  Also tweak the location of the whitespace.  This is all
> to prep for the fix.

I'm thinking you didn't put a lot of hours into that description.
Wanna try again?
