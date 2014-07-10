Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaGJN13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:27:29 -0400
Received: from canardo.mork.no ([148.122.252.1]:58924 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaGJN11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:27:27 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v7 03/33] net: set name_assign_type in alloc_netdev()
Organization: m
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	<1404980258-30853-4-git-send-email-teg@jklm.no>
	<87tx6ph8u5.fsf@nemi.mork.no>
	<CAG-2HqVvW2dh5y8xn9v-B29ohFTcPGgY3NY-P5y_xZu0SGgG3g@mail.gmail.com>
	<87ha2ph2ow.fsf@nemi.mork.no>
	<CAG-2HqXZe26RVnWCKpCfkPmP+OOA5fnrUL-o3+258KLTHPoxOA@mail.gmail.com>
Date: Thu, 10 Jul 2014 15:27:07 +0200
In-Reply-To: <CAG-2HqXZe26RVnWCKpCfkPmP+OOA5fnrUL-o3+258KLTHPoxOA@mail.gmail.com>
	(Tom Gundersen's message of "Thu, 10 Jul 2014 15:02:41 +0200")
Message-ID: <87zjghfiok.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Gundersen <teg@jklm.no> writes:

> What I suggest to do is:
>
> Leave NET_NAME_UNKNOWN in alloc_etherdev() (and any similar
> constructs), but in the cases where we know that the final name set
> before netdev_register() is some template, I'd still set this to
> NET_NAME_ENUM as we do now to make it clear which cases have been
> reviewed. So the patchset does not change much, but it would eliminate
> any risk of false positives.
>
> Does that sound reasonable to you?

Yes, sure.  Although I'm not at all convinced about the value.  But I
don't need to be, as that is not for me to decide :-)



Bjørn
