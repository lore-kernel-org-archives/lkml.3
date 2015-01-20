Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbbATQzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:55:36 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:61044 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbbATQze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:55:34 -0500
Date: Tue, 20 Jan 2015 16:55:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 5/7] mfd: cros_ec: Instantiate ChromeOS EC
 character device
Message-ID: <20150120165527.GH30656@x1>
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
 <1420205572-2640-6-git-send-email-javier.martinez@collabora.co.uk>
 <20150120082013.GU21886@x1>
 <54BE7C53.8070605@collabora.co.uk>
 <20150120162952.GB30656@x1>
 <54BE83FF.7030709@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE83FF.7030709@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Javier Martinez Canillas wrote:

> Hello Lee,
> 
> On 01/20/2015 05:29 PM, Lee Jones wrote:
> > 
> > It's not a blocker, but it is a ridiculous name to use inside the
> > driver/ directory 'cos almost everything is a dev(ice) here.
> > 
> 
> Right, do you think that "cros-ec-chardev" will be a more suitable
> name? Sorry, I'm really bad at naming things...

But is it really a chardev?  Don't chardevs usually live in
drivers/char?  It probably uses a chardev node in /dev, but what does
it really do?  What information can/will userspace obtain from this
memory block?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
