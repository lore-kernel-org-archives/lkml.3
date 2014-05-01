Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbaEASdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:33:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63411 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750727AbaEASds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:33:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Stratos Karafotis <stratosk@semaphore.gr>
Subject: Re: linux-next: manual merge of the pm tree with the mips tree
Date: Thu, 01 May 2014 20:50:18 +0200
Message-ID: <7356166.EVKMfYyT94@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140501120932.ff26772f983a436b4453c915@canb.auug.org.au>
References: <20140501120932.ff26772f983a436b4453c915@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2014 12:09:32 PM Stephen Rothwell wrote:
> 
> --Signature=_Thu__1_May_2014_12_09_32_+1000_d7zY1SkU6vg6nEQn
> Content-Type: text/plain; charset=US-ASCII
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> arch/mips/loongson/lemote-2f/clock.c between commit a68ce6507a45
> ("MIPS/loongson2_cpufreq: Fix CPU clock rate setting") from the mips tree
> and commit 4966ee4037fe ("mips: lemote 2f: Use cpufreq_for_each_entry
> macro for iteration") from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
