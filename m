Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaGHSgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:36:04 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:34517 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbaGHSgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:36:02 -0400
Message-ID: <53BC3A0E.4060505@iki.fi>
Date: Tue, 08 Jul 2014 21:35:58 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] dvb-frontends: remove unnecessary break after goto
References: <1404840181-29822-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404840181-29822-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 85.23.164.97
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moikka Fabian!
I have no reason to decline that patch (I will apply it) even it has 
hardly meaning. But is there now some new tool which warns that kind of 
issues?

regards
Atnti


On 07/08/2014 08:23 PM, Fabian Frederick wrote:
> Cc: Antti Palosaari <crope@iki.fi>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   drivers/media/dvb-frontends/af9013.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
> index fb504f1..ecf6388 100644
> --- a/drivers/media/dvb-frontends/af9013.c
> +++ b/drivers/media/dvb-frontends/af9013.c
> @@ -470,7 +470,6 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
>   		break;
>   	default:
>   		goto err;
> -		break;
>   	}
>
>   	for (i = 0; i < len; i++) {
>

-- 
http://palosaari.fi/
