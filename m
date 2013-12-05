Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3LERxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:53:31 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60880 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab3LERx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <20131204175350.3449.17368@hit-nxdomain.opendns.com>
References: <20131204175350.3449.17368@hit-nxdomain.opendns.com>
Date: Thu, 5 Dec 2013 09:53:26 -0800
X-Google-Sender-Auth: MQGP_n2k5BpqWyt9BMqzY52Dbmc
Message-ID: <CA+55aFz3sxb5h+m2eC8KniJjE4dA1F2Pzcu=9DfZRRzZakiBDw@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs Maintainer update
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 9:53 AM, Chris Mason <clm@fb.com> wrote:
>
> Instead of diffstat etc, I've put the patch below.  The commit is also
> signed, my updated key should be floating around the pgp servers now.

You've done something to the git tree since your test request, because
now the signed tag isn't there any more, now it's just a regular
branch.

Mind re-uploading the *tag*, which is where the signature is?

              Linus
