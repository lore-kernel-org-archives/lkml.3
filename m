Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3IILH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:07:58 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63194 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab3IILH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <1378561605-18998-5-git-send-email-konrad.wilk@oracle.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com> <1378561605-18998-5-git-send-email-konrad.wilk@oracle.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 16:37:16 +0530
Message-ID: <CALkWK0mWC-iQBGGBvhuz1B-q83vNq0QE4jP-HQDvfPxtSmcrdA@mail.gmail.com>
Subject: Re: [PATCH 4/5] xen/spinlock: Don't setup xen spinlock IPI kicker if disabled.
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> There is no need to setup this IPI kicker if we are never going
> to use the paravirtualized ticketlock mechanism.

Excellent patch; the important takeaway is that paravirtualization is
still quite useful in the real world.
