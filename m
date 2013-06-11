Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3FKNuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:50:05 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38594 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab3FKNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:50:03 -0400
Message-ID: <51B72BD3.4000200@metafoo.de>
Date: Tue, 11 Jun 2013 15:53:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <20130611120530.GF3330@laptop>
In-Reply-To: <20130611120530.GF3330@laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 02:05 PM, Lee Jones wrote:
>> I believe the whole thing should go via the MFD tree. It touches also
>> input & iio subsystem. I collected ACKs where I got some in the meantime.
>>
>> I added Lee Jones because I hear no sign of life from Samuel.
> 
> Unfortunately I can't be of any added help here, as I also send my
> pull-requests though Sam.
> 
> Sorry I couldn't be of any more use Sebastian.
> 

It sometimes takes him a week or two to respond, but Samuel is pretty reliable
when it comes to merging patches, so I wouldn't worry about it.

- Lars
