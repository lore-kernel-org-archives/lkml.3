Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3IKSrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:47:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34315 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab3IKSrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:47:18 -0400
Message-ID: <1378925224.26698.90.camel@localhost>
Subject: Re: TPMs and random numbers
From: David Safford <safford@us.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Ted Ts'o" <tytso@mit.edu>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Date: Wed, 11 Sep 2013 14:47:04 -0400
In-Reply-To: <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
References: <1378920168.26698.64.camel@localhost>
	 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091118-5806-0000-0000-000022B3D72E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 10:49 -0700, Andy Lutomirski wrote:
> On Wed, Sep 11, 2013 at 10:22 AM, David Safford <safford@us.ibm.com> wrote:
> >>On 09/09/2013 02:11 PM, H. Peter Anvin wrote:
> 
> A TPM that has an excellent internal entropy source and is FIPS 140-2
> compliant with no bugs whatsoever may still use Dual_EC_DRBG, which
> looks increasingly likely to be actively malicious.

I don't know of any that do so (it's more complex and slower than
the alternatives). 

> I'd be *much* happier if my system read a few hundred random bytes
> from the TPM at startup and fed those bytes into the kernel's entropy
> pool.  This should IMO happen at startup as early as possible.

I agree completely that the ideal case is a system with good entropy
sources, including a TPM, and all these mixed as early as possible.
But I also think that the existing (certified) TPMs are good enough 
for direct use.

dave


