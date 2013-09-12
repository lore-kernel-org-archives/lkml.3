Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3ILX6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:58:09 -0400
Received: from longford.logfs.org ([213.229.74.203]:60257 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3ILX6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:58:04 -0400
Date: Thu, 12 Sep 2013 18:23:09 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Safford <safford@us.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Subject: Re: TPMs and random numbers
Message-ID: <20130912222309.GH3809@logfs.org>
References: <1378920168.26698.64.camel@localhost>
 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <1378925224.26698.90.camel@localhost>
 <20130912215718.GF3809@logfs.org>
 <CAFtxgO5dzJJvFR2tz2Cztvp9rkkyFevfsPxnnOF-q731W8JDxA@mail.gmail.com>
 <20130912221340.GG3809@logfs.org>
 <CALCETrWp_QSstE1NB_bB6uWLEJNcT5NmcuK9MRRQjmGFpy6b=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWp_QSstE1NB_bB6uWLEJNcT5NmcuK9MRRQjmGFpy6b=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 September 2013 16:51:15 -0700, Andy Lutomirski wrote:
> 
> Supposedly, the Linux entropy pool has the property that mixing in
> even actively malicious data is no worse than not mixing in anything
> at all.

It is worse in three ways:
- it costs performance,
- it may create a false sense of safety and
- it actively does harm if we credit it as entropy.

How much weight you assign to each of those is up to you.  So long as
we don't credit any of it as entropy, I am not too adverse to mixing
it in.  But I can equally see benefit in burning the bridges.

Jörn

--
There are two ways of constructing a software design: one way is to make
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare
