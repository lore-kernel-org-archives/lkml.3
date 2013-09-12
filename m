Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3ILXjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:39:51 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:50854 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3ILXjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:39:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130912215718.GF3809@logfs.org>
References: <1378920168.26698.64.camel@localhost>
	<CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
	<1378925224.26698.90.camel@localhost>
	<20130912215718.GF3809@logfs.org>
Date: Thu, 12 Sep 2013 19:39:47 -0400
X-Google-Sender-Auth: qTY5StJ_n_M1mBepikjyACDfN9w
Message-ID: <CAFtxgO5dzJJvFR2tz2Cztvp9rkkyFevfsPxnnOF-q731W8JDxA@mail.gmail.com>
Subject: Re: TPMs and random numbers
From: Jeff Garzik <jgarzik@pobox.com>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: David Safford <safford@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 5:57 PM, Jörn Engel <joern@logfs.org> wrote:
> On Wed, 11 September 2013 14:47:04 -0400, David Safford wrote:
>> But I also think that the existing (certified) TPMs are good enough
>> for direct use.

> That is equivalent to trusting the TPM chip not to be malicious.  It

Indeed.  While it need not be rngd or userland at all, it seems
reasonable to require any hardware RNG to have its data pushed through
AES mix steps (as kernel random does now IIUC).

      Jeff
