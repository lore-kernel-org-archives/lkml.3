Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3HRQik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 12:38:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52929 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753299Ab3HRQij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 12:38:39 -0400
Message-ID: <1376843917.2027.26.camel@joe-AO722>
Subject: Re: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
From: Joe Perches <joe@perches.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Date: Sun, 18 Aug 2013 09:38:37 -0700
In-Reply-To: <5210F61E.2060207@gmail.com>
References: <5210F48F.3030504@gmail.com> <5210F61E.2060207@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-08-18 at 17:28 +0100, Paul McQuade wrote:
> >From c21d0da84c92d351f37b70c0d9c01a66fcb84e88 Mon Sep 17 00:00:00 2001

Please send patches to yourself and make sure they
apply correctly before sending them to other people
and lists.

This one has two newlines where only a single newline
should exist throughout the patch.

> Subject: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
> 
> __Function__ gets replaced with __func__

Also, please review your commit message and subject
for consistency and intelligibility before resending.

__Function__ is not getting replaced.


