Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaG3OfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:35:07 -0400
Received: from mail.sf-mail.de ([78.47.74.12]:35596 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbaG3OfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:35:04 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Wed, 30 Jul 2014 16:34:40 +0200
Message-ID: <3912417.mEOGY4YVAb@devpool02>
User-Agent: KMail/4.13.3 (Linux/3.15.5-1.g01d2774-desktop; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1406212287-9855-1-git-send-email-tytso@mit.edu>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:

It's me again, finding only one issue per cycle :/

> 	EAGAIN		The requested entropy was not available, and
> 			getentropy(2) would have blocked if GRND_BLOCK flag
> 			was set.

"if GRND_NONBLOCK flag was not set"

Eike
