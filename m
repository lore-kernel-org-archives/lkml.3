Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3LRSez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:34:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:46778 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3LRSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:34:53 -0500
Message-ID: <52B1EAC5.4020104@linutronix.de>
Date: Wed, 18 Dec 2013 19:34:45 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: am335x: IIO/ADC fixes if used together with TSC
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de> <d916c9be-2614-41b8-ae92-67bf1a57ed74@email.android.com>
In-Reply-To: <d916c9be-2614-41b8-ae92-67bf1a57ed74@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 06:25 PM, Jonathan Cameron wrote:
> Given timing I suspect that by the we have reviewed these will be too late in this cycle so will hit in the merge window plus stable.
> 
> Also some of these are cleanups rather than fixes so should normally be separate from fixes and applied after them as they are not 
> Stable material.

I tried to keep 5/5 as small as possible so I factor individual and
separate changes as good as possible as long as the drivers remained
functional. That means 1-4 are mostly pre-work for 5/5 and that makes
5/5 depends on them.

Tagging 5/5 stable I would prefer to take 1-4, too to keep the backport
effort small. The clash due to the continues mode which is v3.13 is
probably small. This said, I think it is the best to backport it stable
if someone asks for it (unless the majority here thinks otherwise).

Are you saying this is too late for v3.13 or v3.14-rc1?

Sebastian
