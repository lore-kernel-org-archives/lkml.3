Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3LIVap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:30:45 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:35674 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3LIVan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:30:43 -0500
MIME-Version: 1.0
In-Reply-To: <CACwUX0PGGM99-2H41S0eqOVLsh-7+Dan+gcy9deK1movx_wWPQ@mail.gmail.com>
References: <CACwUX0PEYGsNMDvy85EsrApWzNU3iTyY-1KHMaj1ay0xxKX6RQ@mail.gmail.com>
	<CACwUX0PGGM99-2H41S0eqOVLsh-7+Dan+gcy9deK1movx_wWPQ@mail.gmail.com>
Date: Mon, 9 Dec 2013 14:30:42 -0700
Message-ID: <CAKocOOOT2J_+hmEsAnAJVWV7TOqgApd3Lih+3WaRob4e8Nex4Q@mail.gmail.com>
Subject: Re: UBIFS recovery taking too long
From: Shuah Khan <shuahkhan@gmail.com>
To: David Mosberger-Tang <dmosberger@gmail.com>, dedekind1@gmail.com,
        adrian.hunter@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ubifs maintainers.

-- Shuah

On Mon, Dec 9, 2013 at 1:53 PM, David Mosberger-Tang
<dmosberger@gmail.com> wrote:
> I've had no luck getting any response from the linux-mtd mailing list
> regarding the issue reported below.
> I think it is a very serious issue since it can easily render an
> embedded system unusable.
>
>   --david
>
> ---------- Forwarded message ----------
> From: David Mosberger-Tang <dmosberger@gmail.com>
> Date: Thu, Nov 7, 2013 at 11:44 AM
> Subject: UBIFS recovery taking too long
> To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
>
>
> We recently encountered a strange issue where UBIFS recovery is
> suddenly taking a lot longer than usual (v3.7-based kernel).  In our
> case, recovery took about 30 seconds.  This caused a serious problem
> because our watchdog timer was set to 15 seconds, effectively
> rendering the devices unbootable.
>
> Does anybody know what triggers this slow recovery mode?  Also, how
> can we calculate a worst-case recovery time for a given flash
> chip-size.
>
> Thanks,
>
>   --david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
