Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3G0Kp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:45:27 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53576 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3G0Kp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:45:26 -0400
Message-ID: <51F3B2D6.5030703@kernel.org>
Date: Sat, 27 Jul 2013 12:45:26 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH] Documentation: devres: add IIO device alloc/free functions
 to list
References: <1374568775-15491-1-git-send-email-x0199363@ti.com>
In-Reply-To: <1374568775-15491-1-git-send-email-x0199363@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/13 09:39, Oleksandr Kravchenko wrote:
> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> 
> Add devm_iio_device_alloc() and devm_iio_device_free() functions
> to list of supported calls.
> 
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Applied to the togreg branch of iio.git.

Thanks,
> ---
>  Documentation/driver-model/devres.txt |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index b467145..1d32332 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -237,6 +237,10 @@ MEM
>    devm_kzalloc()
>    devm_kfree()
>  
> +IIO
> +  devm_iio_device_alloc()
> +  devm_iio_device_free()
> +
>  IO region
>    devm_request_region()
>    devm_request_mem_region()
> 
