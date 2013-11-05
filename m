Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3KEM6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:58:53 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:39250 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3KEM6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:58:51 -0500
Message-ID: <1383656116.17256.0.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: randconfig build error with next-20131104, in security/integrity
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org
Date: Tue, 05 Nov 2013 07:55:16 -0500
In-Reply-To: <201311052112.DCC60296.MFOOFSOHJVtLQF@I-love.SAKURA.ne.jp>
References: <CA+r1Zhir86Mdmps5N1awK7mJxf1CWgkr-RDKYVhmpj_3+oYyYQ@mail.gmail.com>
	 <1383606829.15186.25.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <201311052112.DCC60296.MFOOFSOHJVtLQF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110512-7164-0000-0000-00000305F228
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 21:12 +0900, Tetsuo Handa wrote:
> Mimi Zohar wrote:
> > @@ -132,24 +133,22 @@ static inline int integrity_digsig_verify(const unsigned int id,
> >  	return -EOPNOTSUPP;
> >  }
> >  
> > +static int integrity_init_keyring(const unsigned int id)
> 
> Please add inline keyword, or compiler makes noisy warning.

Thanks!

Mimi

> > +{
> > +	return 0;
> > +}
> >  #endif /* CONFIG_INTEGRITY_SIGNATURE */
> 


