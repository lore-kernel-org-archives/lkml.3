Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaGVOgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:36:16 -0400
Received: from mail.sf-mail.de ([78.47.74.12]:57584 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaGVOgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:36:15 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org,
        deraadt@cvs.openbsd.org
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Date: Tue, 22 Jul 2014 16:36:05 +0200
Message-ID: <5099206.RVhAB5vDXY@devpool02>
User-Agent: KMail/4.13.3 (Linux/3.15.5-1.g01d2774-desktop; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1405718127-30042-1-git-send-email-tytso@mit.edu>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	EAGAIN		The requested entropy was not available, and the
> 			getentropy(2) would have blocked if GRND_BLOCK flag
> 			was set.

I think either "and the call to getentropy(2)" or "and getentropy(2)" here.

Greetings,

Eike
