Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3IMCOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:14:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:59367 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab3IMCOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:14:15 -0400
Date: Thu, 12 Sep 2013 22:13:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Jeff Garzik <jgarzik@pobox.com>,
        David Safford <safford@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Subject: Re: TPMs and random numbers
Message-ID: <20130913021349.GB9445@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Jeff Garzik <jgarzik@pobox.com>, David Safford <safford@us.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
	Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
	Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	David Safford <safford@watson.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>,
	"Johnston, DJ" <dj.johnston@intel.com>
References: <1378920168.26698.64.camel@localhost>
 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <1378925224.26698.90.camel@localhost>
 <20130912215718.GF3809@logfs.org>
 <CAFtxgO5dzJJvFR2tz2Cztvp9rkkyFevfsPxnnOF-q731W8JDxA@mail.gmail.com>
 <20130912221340.GG3809@logfs.org>
 <CALCETrWp_QSstE1NB_bB6uWLEJNcT5NmcuK9MRRQjmGFpy6b=w@mail.gmail.com>
 <20130912222309.GH3809@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130912222309.GH3809@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 06:23:09PM -0400, Jörn Engel wrote:
> It is worse in three ways:
> - it costs performance,
> - it may create a false sense of safety and
> - it actively does harm if we credit it as entropy.
> 
> How much weight you assign to each of those is up to you.  So long as
> we don't credit any of it as entropy, I am not too adverse to mixing
> it in.  But I can equally see benefit in burning the bridges.

Well, mixing it in and using /dev/[u]random is certainly better than
blindly using the output from the RNG from the TPM directly as a
key.

I'm not sure what you mean by "burning the bridges"; what is the
alternative that you are suggesting?

						- Ted
