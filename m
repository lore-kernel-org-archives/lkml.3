Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3JNWxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:53:44 -0400
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:55889 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932260Ab3JNWxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:53:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2894:2914:3138:3139:3140:3141:3142:3622:3867:3871:387
X-HE-Tag: moon84_1fcac6f1d8e5e
X-Filterd-Recvd-Size: 1605
Message-ID: <1381791216.16896.8.camel@joe-AO722>
Subject: Re: [PATCH v4] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Ingo Molnar <mingo@elte.hu>,
        linux-doc@vger.kernel.org
Date: Mon, 14 Oct 2013 15:53:36 -0700
In-Reply-To: <525C7278.3090200@gmail.com>
References: <525C7278.3090200@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 09:38 +1100, Ryan Mallon wrote:
> This is a temporary solution only, but fixes a minor security hole when
> kptr_restrict=1. I am working to fix this properly, but there is still
> some discussion around how to achieve this, see here:

Glad you changed your mind.


