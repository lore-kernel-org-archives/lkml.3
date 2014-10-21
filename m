Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbaJUWGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:06:32 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:55417 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbaJUWGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:06:30 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:39bc:72a7:a0a6:e1f0]
In-Reply-To: <CAOFdcFPu3AgZ8cwqjF2EZeO0+_2wF_zC_aHxTCCOzWKkbNwV6w@mail.gmail.com>
References: <1412811091-26702-1-git-send-email-pefoley2@pefoley.com> <CAOFdcFPu3AgZ8cwqjF2EZeO0+_2wF_zC_aHxTCCOzWKkbNwV6w@mail.gmail.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 21 Oct 2014 18:06:09 -0400
Message-ID: <CAOFdcFMywBpOeUrOg1KU_M9PSHuJ+kCq55WDQ8yU+wqN2U5ASA@mail.gmail.com>
Subject: Re: [PATCH] Only build Documentation/ when not cross-compiling
To: LKML <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, torvalds@linuxfoundation.org,
        Peter Foley <pefoley2@pefoley.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 9:53 AM, Peter Foley <pefoley2@pefoley.com> wrote:
> Turns out this doesn't work if CROSS_COMPILE is set in the environment.
> I'll send another version shortly.

It seems there is more interested in cross-compiling Documentation
than I anticipated, so please ignore this as I'll be trying a
different approach.

Thanks,

Peter
