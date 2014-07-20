Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaGTR1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:27:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60399 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaGTR1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:27:49 -0400
X-Auth-Info: k5/adMuK3GQtAs3q+0KFiFGEL+gWNFi5I5jNcAcmjLE=
From: Andreas Schwab <schwab@linux-m68k.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
X-Yow: ..  the HIGHWAY is made out of LIME JELLO and my HONDA
 is a barbequed OYSTER!  Yum!
Date: Sun, 20 Jul 2014 19:27:42 +0200
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu> (Theodore
	Ts'o's message of "Thu, 17 Jul 2014 05:18:15 -0400")
Message-ID: <87tx6cvt2p.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:

> ERRORS
> 	EINVAL		The buflen value was invalid.

Also on unknown flags?  Without that it would be impossible to probe for
implemented flags.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
