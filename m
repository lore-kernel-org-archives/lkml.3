Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaGWM1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:27:16 -0400
Received: from canardo.mork.no ([148.122.252.1]:54447 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaGWM1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:27:15 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drbd: Remove fix me statements
Organization: m
References: <1406053161-5048-1-git-send-email-xerofoify@gmail.com>
Date: Wed, 23 Jul 2014 14:27:00 +0200
In-Reply-To: <1406053161-5048-1-git-send-email-xerofoify@gmail.com> (Nicholas
	Krause's message of "Tue, 22 Jul 2014 14:19:21 -0400")
Message-ID: <8738dsi7l7.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause <xerofoify@gmail.com> writes:

> This removes no longer needed fix me statements

If you claim that they no longer are needed then I expect you to explain
what's changed since they were added.

> as the spinlocks
> are needed to protect against other users of the list accessing
>  it when items on it are being moved off it.

Yes, that's most likely why the locking is there.

The FIXMEs on the other hand, are probably there to tell you that it
would be nice to get rid of the double locking.  I don't see that
changing.


Bjørn

