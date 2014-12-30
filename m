Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaL3WX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:23:29 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:44184 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbaL3WX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:23:28 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54A325D8.9090902@mev.co.uk>
Date: Tue, 30 Dec 2014 22:23:20 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: jitendra kumar khasdev <jkhasdev@gmail.com>, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, chase.southwood@gmail.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: driver : fix max 80 character coding
 style issue in s626.c
References: <1419845268-7833-1-git-send-email-jkhasdev@gmail.com>
In-Reply-To: <1419845268-7833-1-git-send-email-jkhasdev@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/12/14 09:27, jitendra kumar khasdev wrote:
> This is a patch to the s626.c file that fixes up a maximum 80 character limit
> warning found by the checkpatch.pl tool
>
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>   drivers/staging/comedi/drivers/s626.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index fc497dd..77f715b 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -2534,7 +2534,8 @@ static int s626_initialize(struct comedi_device *dev)
>   	for (i = 0; i < 2; i++) {
>   		writel(S626_I2C_CLKSEL, dev->mmio + S626_P_I2CSTAT);
>   		s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> -		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
> +		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc,
> +		0);

Technically it meets the requirements, but our comedi house style is to 
indent the continuation of the statement just past the opening 
bracket/parenthesis like so:

		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc,
				     0);

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
