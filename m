Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3KYRNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:13:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42677 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab3KYRNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:13:06 -0500
Date: Mon, 25 Nov 2013 18:13:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: randconfig build error with next-20131125, in drivers/iio/light
Message-ID: <20131125171301.GB11463@pd.tnic>
References: <CA+r1ZhinxJBB3dgCKxoMXV0ioVR0jrS7ha=SY-qT212AvDSkVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhinxJBB3dgCKxoMXV0ioVR0jrS7ha=SY-qT212AvDSkVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:04:44AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/iio/light/tcs3472.c: In function ‘tcs3472_trigger_handler’:
> drivers/iio/light/tcs3472.c:195:2: error: implicit declaration of
> function ‘iio_push_to_buffers_with_timestamp’
> [-Werror=implicit-function-declaration]
>   iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
>   ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/iio/light/tcs3472.o] Error 1

Feel like giving it a try to write a fix for it? It seems to me
tcs3472.c should depend on IIO_BUFFER... :-)

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
