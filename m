Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbbATQgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:36:23 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60944 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbATQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:36:22 -0500
Message-ID: <54BE83FF.7030709@collabora.co.uk>
Date: Tue, 20 Jan 2015 17:36:15 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 5/7] mfd: cros_ec: Instantiate ChromeOS EC character
 device
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk> <1420205572-2640-6-git-send-email-javier.martinez@collabora.co.uk> <20150120082013.GU21886@x1> <54BE7C53.8070605@collabora.co.uk> <20150120162952.GB30656@x1>
In-Reply-To: <20150120162952.GB30656@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 01/20/2015 05:29 PM, Lee Jones wrote:
> 
> It's not a blocker, but it is a ridiculous name to use inside the
> driver/ directory 'cos almost everything is a dev(ice) here.
> 

Right, do you think that "cros-ec-chardev" will be a more suitable
name? Sorry, I'm really bad at naming things...

Best regards,
Javier
