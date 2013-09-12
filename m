Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3ILXc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:32:29 -0400
Received: from longford.logfs.org ([213.229.74.203]:60229 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3ILXc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:32:27 -0400
Date: Thu, 12 Sep 2013 17:57:18 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Safford <safford@us.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Ted Ts'o" <tytso@mit.edu>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Subject: Re: TPMs and random numbers
Message-ID: <20130912215718.GF3809@logfs.org>
References: <1378920168.26698.64.camel@localhost>
 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <1378925224.26698.90.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378925224.26698.90.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 September 2013 14:47:04 -0400, David Safford wrote:
>
> But I also think that the existing (certified) TPMs are good enough 
> for direct use.

That is equivalent to trusting the TPM chip not to be malicious.  It
requires trusting the chip designer, trusting every single employee of
the chip designer, as some of them may be plants from a random
countries spook organization, trusting the fab where the chip was
manufactured, trusting your local dealer not to replace one chip with
another in a similar packaging, trusting third-party components the
designers may have incorporated, trusting intermediate steps between
designer and fab or fab and local dealer, trusting your own employees,
etc.

If you sum it all up, you quickly depend on hundreds of people in
multiple countries that have the ability to subvert your chips RNG
without you being able to notice any difference.

Or rather, you would only be able to notice the difference if you were
the person that subverted the chip.  So the NSA may be able to tell
whether the Chinese have subverted a specific chip.  Honi soit...

Jörn

--
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
