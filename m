Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaFNPNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:13:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:44233 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbaFNPNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:13:10 -0400
Message-ID: <539C66F7.2040607@kernel.org>
Date: Sat, 14 Jun 2014 16:15:03 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jimmy Picard <jimmyp11f155@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: fix coding style
References: <1402638961-14176-1-git-send-email-jimmyp11f155@gmail.com>
In-Reply-To: <1402638961-14176-1-git-send-email-jimmyp11f155@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/14 06:56, Jimmy Picard wrote:
> This patch fixes coding style reported by checkpatch.pl that missing
> a blank line after declarations.
>
> Signed-off-by: Jimmy Picard <jimmyp11f155@gmail.com>
Hmm. This is in the trivial enough to be marginally annoying
category of basically noise.  Normally I'd only take this as
part of a larger series doing something more interesting, but
what the heck.

Applied to the togreg branch of iio.git

J
> ---
>   drivers/staging/iio/iio_simple_dummy.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/staging/iio/iio_simple_dummy.c b/drivers/staging/iio/iio_simple_dummy.c
> index fd334a0..bf78e6f 100644
> --- a/drivers/staging/iio/iio_simple_dummy.c
> +++ b/drivers/staging/iio/iio_simple_dummy.c
> @@ -550,6 +550,7 @@ error_ret:
>   static __init int iio_dummy_init(void)
>   {
>   	int i, ret;
> +
>   	if (instances > 10) {
>   		instances = 1;
>   		return -EINVAL;
> @@ -577,6 +578,7 @@ module_init(iio_dummy_init);
>   static __exit void iio_dummy_exit(void)
>   {
>   	int i;
> +
>   	for (i = 0; i < instances; i++)
>   		iio_dummy_remove(i);
>   	kfree(iio_dummy_devs);
>

