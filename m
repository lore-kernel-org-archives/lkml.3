Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936539Ab3DIJVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:21:34 -0400
Received: from smtp1.goneo.de ([212.90.139.80]:45241 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559Ab3DIJVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:21:32 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.9
From: Lars Poeschel <poeschel@lemonage.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v1] pwm: add sysfs interface
Date: Tue, 9 Apr 2013 11:21:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, rob@landley.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <1364997536-9246-1-git-send-email-larsi@wh2.tu-dresden.de> <201304081315.37794.poeschel@lemonage.de> <20130408113457.GA17028@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130408113457.GA17028@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091121.20510.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013 at 13:34:58, Thierry Reding wrote:
> By the way, would you mind elaborating a bit on the various use-cases
> that you have? I'm interested in what people use the PWM subsystem for
> and you seem to be the only one currently using it from userspace. I'm
> hoping I can get a better understanding of what the PWM subsystem nedes
> to provide if I know what people use it for.

Sure, but there is not much about it: 
The PWM output is connected to an electronic circuit that converts the 
signal to a voltage. The higher the duty cycle is the higher the voltage 
gets. In fact this is a simple DAC converter. This voltage limits the 
electric current a battery recharger uses to charge a battery. We think 
controlling the PWM from userspace is a simple way for our application to 
control the voltage.
If you have further questions feel free to ask.

Lars
