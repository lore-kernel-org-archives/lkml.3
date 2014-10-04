Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaJDJWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 05:22:13 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:44529 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaJDJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 05:22:11 -0400
Date: Sat, 4 Oct 2014 11:22:05 +0200
From: Marc Burkhardt <marc@osknowledge.org>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Marc Burkhardt <marc@osknowledge.org>, linux-kernel@vger.kernel.org
Subject: Re: Slowdown due to threads bouncing between HT cores
Message-ID: <20141004092205.GA12973@localhost>
References: <20141003194428.GA27084@sesse.net>
 <20141003211152.GB3889@localhost>
 <20141003211417.GA17326@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003211417.GA17326@sesse.net>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://marc.ngoe.de/pubkey.asc
X-Operating-System: Linux marc 3.10.55-desper
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steinar H. Gunderson <sgunderson@bigfoot.com> [2014-10-03 23:14:17 +0200]:

> On Fri, Oct 03, 2014 at 11:11:52PM +0200, Marc Burkhardt wrote:
> > As I understand your mail, you problem is quite similar, isn't it?
> 
> I guess it depends on how often your process migrates. If it happens, like,
> every second, it's not a big problem (and probably is expected).
> If it happens all the time, it might be; it depends a bit on a number of
> factors.

Hi Steinar,

you say the behavior is probably expected, but I still don't get the point why
this could be normal or even wanted. There's a cost for migrating the process to
another CPU. In case my machine has 4 cores, 3 of them 'idle' and that 1 running
process that keeps being migrated ... where's the benefit of migrating it?

Do you have any source/docs where I could read about this?

Thanks,
Marc

> 
> /* Steinar */
> -- 
> Homepage: http://www.sesse.net/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Marc Burkhardt
