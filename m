Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3FYMKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:10:14 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65135 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FYMKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130403172534.528d04c5@mschwide>
References: <20130403172534.528d04c5@mschwide>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jun 2013 13:09:51 +0100
X-Google-Sender-Auth: LB_sociyCphPXjN_DXQ_5OCIl_s
Message-ID: <CACxGe6sYM8QPB-ZZkgB0+f81CZHULPi5zPAsWb5dzHiRgU+w6Q@mail.gmail.com>
Subject: Re: [GIT PULL] s390 patches for the 3.9-rc6
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 4:25 PM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> Hi Linus,
>
> please pull from the 'for-linus' branch of
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
>
> to receive the following updates: Just a bunch of bugfixes.
>
> Heiko Carstens (4):
>       drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies

Is anyone currently working on fixing this? s390 is the only
architecture left that does not enable GENERIC_HARDIRQS. It's painful
to keep adding dependencies on GENERIC_HARDIRQS to driver configs.

g.
