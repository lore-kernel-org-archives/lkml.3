Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3IKTGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:06:35 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51608 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3IKTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:06:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130911184509.GB13397@thunk.org>
References: <1378920168.26698.64.camel@localhost>
	<CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
	<20130911184509.GB13397@thunk.org>
Date: Wed, 11 Sep 2013 15:06:33 -0400
X-Google-Sender-Auth: Dfv4NFokmXAT4hoe0fCOx5SB-bM
Message-ID: <CAFtxgO7XKbNn1-VW6Ha9P9wj7VAHw6Upar9udgy6dMrFNAHU0Q@mail.gmail.com>
Subject: Re: TPMs and random numbers
From: Jeff Garzik <jgarzik@pobox.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        David Safford <safford@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 2:45 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> We should definitely do this.  If the TPM driver could fetch some
> randomness and then call add_device_randomness() to feed this into the
> random driver's entropy pool when it initializes itself, that would be
> ***really*** cool.


rngd already does this.

     Jeff
