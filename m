Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbbATPkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:40:46 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60872 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbbATPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:40:44 -0500
Message-ID: <54BE76F6.9000707@collabora.co.uk>
Date: Tue, 20 Jan 2015 16:40:38 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/7] mfd: cros_ec: Use fixed size arrays to
 transfer data with the EC
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk> <1420205572-2640-2-git-send-email-javier.martinez@collabora.co.uk> <20150120074803.GR21886@x1>
In-Reply-To: <20150120074803.GR21886@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 01/20/2015 08:48 AM, Lee Jones wrote:
> 
> Looks okay to me, but I'd be happy with some more reviews from the
> Chrome guys.  I would especially like some knowledgeable type to
> answer your EC_PROTO2_MAX_PARAM_SIZE question.  If no one does, I
> guess it can always be changed later.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
>

Great, thanks a lot.

Best regards,
Javier

