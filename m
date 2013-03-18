Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3CRPmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:42:21 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:64189 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab3CRPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:42:20 -0400
Message-ID: <1363621331.1335.176.camel@x61.thuisdomein>
Subject: Re: [PATCH] checkpatch: stop checking for CONFIG_EXPERIMENTAL
From: Paul Bolle <pebolle@tiscali.nl>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 16:42:11 +0100
In-Reply-To: <CAGXu5jLfq-AqkTyoZRdcJ-S07h0pFKBXDL=KBi7-nT7NQtftKg@mail.gmail.com>
References: <1363469435.1335.137.camel@x61.thuisdomein>
	 <CAGXu5jLfq-AqkTyoZRdcJ-S07h0pFKBXDL=KBi7-nT7NQtftKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2013 15:42:11.0671 (UTC) FILETIME=[28116E70:01CE23EF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 15:38 -0700, Kees Cook wrote:
> Hrm, I actually think it would be better to change this to ERROR
> instead of WARN.

I figured the main reason to add this warning was to prevent people to
add dependencies on EXPERIMENTAL while you were cleaning the tree, which
could mean you had to redo patches each time that happened.

Anyhow, with EXPERIMENTAL gone, this is just one of the mistakes people
can make in using the kconfig system. I'm not sure that we should use
checkpatch to catch these. For this particular case it must also be
noted that if code gets in while still depending on EXPERIMENTAL someone
also missed that this code doesn't get build at all.


Paul Bolle

