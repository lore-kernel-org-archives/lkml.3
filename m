Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3KYRNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:13:23 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55961 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3KYRNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:13:21 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+r1ZhinxJBB3dgCKxoMXV0ioVR0jrS7ha=SY-qT212AvDSkVQ@mail.gmail.com>
References: <CA+r1ZhinxJBB3dgCKxoMXV0ioVR0jrS7ha=SY-qT212AvDSkVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: randconfig build error with next-20131125, in drivers/iio/light
From: Jonathan Cameron <jic23@kernel.org>
Date: Mon, 25 Nov 2013 17:13:09 +0000
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Message-ID: <1bbe329e-a128-4d08-b79c-d9285dbf4aae@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report. We have a fix queued up. I have just been a bit lax sending the pull request. Note I believe the issue is in Linus' tree as well.

Thanks again

Jonathan

Jim Davis <jim.epost@gmail.com> wrote:
>Building with the attached random configuration file,
>
>drivers/iio/light/tcs3472.c: In function ‘tcs3472_trigger_handler’:
>drivers/iio/light/tcs3472.c:195:2: error: implicit declaration of
>function ‘iio_push_to_buffers_with_timestamp’
>[-Werror=implicit-function-declaration]
>  iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
>  ^
>cc1: some warnings being treated as errors
>make[3]: *** [drivers/iio/light/tcs3472.o] Error 1

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
