Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaJQNyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:54:00 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51231 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJQNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:53:58 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.159]
In-Reply-To: <1412811091-26702-1-git-send-email-pefoley2@pefoley.com>
References: <1412811091-26702-1-git-send-email-pefoley2@pefoley.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Fri, 17 Oct 2014 09:53:37 -0400
Message-ID: <CAOFdcFPu3AgZ8cwqjF2EZeO0+_2wF_zC_aHxTCCOzWKkbNwV6w@mail.gmail.com>
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

On Wed, Oct 8, 2014 at 7:31 PM, Peter Foley <pefoley2@pefoley.com> wrote:
> Don't build Documentation targets when cross-compiling.
> They are only for build testing, and use the host headers and compiler
> which can cause cross-compiles to fail.
>

Turns out this doesn't work if CROSS_COMPILE is set in the environment.
I'll send another version shortly.
