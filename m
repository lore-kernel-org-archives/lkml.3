Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3JAQpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:45:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43639 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3JAQpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:45:36 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <1378562915-893-1-git-send-email-teg@jklm.no>
References: <CAMuHMdXDAA3PgbgNrccStUZGByDXuSsMG_yJMwwUWXwMvyOfsA@mail.gmail.com>
 <1378562915-893-1-git-send-email-teg@jklm.no>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 1 Oct 2013 18:45:14 +0200
Message-ID: <CAG-2HqVvm6b5pnS_o4b7=PR_xt6YjVabEfqoxjuj6zUJbn3dNQ@mail.gmail.com>
Subject: Re: [PATCH v3] simplefb: print some info about the registered fb
To: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, tomi.valkeinen@ti.com,
        plagnioj@jcrosoft.com, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 4:08 PM, Tom Gundersen <teg@jklm.no> wrote:
> This is similar to the output printed by efifb.
>
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> ---
> v2: also print smem_len, as requested by David
> v3: don't cast, as requested by Geert

Jean-Christophe and Tomi,

What's the status of this, did either of you pick it up for 3.12 or 3.13?

Cheers,

Tom
