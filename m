Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3CKVgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:36:48 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:62466 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3CKVgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <1362967787-22557-2-git-send-email-ch.naveen@samsung.com>
References: <1362967787-22557-1-git-send-email-ch.naveen@samsung.com>
	<1362967787-22557-2-git-send-email-ch.naveen@samsung.com>
Date: Mon, 11 Mar 2013 14:36:45 -0700
X-Google-Sender-Auth: NanW_oYd0SLX95MQzZgQWsyouPk
Message-ID: <CAD=FV=WedkZdqrob=pvmdr_FD27xtX=riEc5rdiTS3QVPk22SA@mail.gmail.com>
Subject: Re: [PATCH 2/2] hwmon: NTC: add IIO get channel and read support
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, devicetree-discuss@lists.ozlabs.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>, dg77.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Sun, Mar 10, 2013 at 7:09 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> @@ -317,7 +346,7 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>                 return data->pdata->read_ohm(data->pdev);
>
>         if (data->pdata->read_uV) {
> -               read_uV = data->pdata->read_uV(data->pdev);
> +               read_uV = data->pdata->read_uV(data->pdata);

This doesn't apply for me.  Did you perhaps accidentally send up a
patch against the version of the driver that's in the Chrome OS tree?
You should be sending patches against some tree that's upstream
(linux, linux-next, iio, ...).

Thanks!

-Doug
