Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaBDUUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:20:15 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:5770 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaBDUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:20:10 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 04 Feb 2014 12:08:02 -0800
Message-ID: <52F14B79.7050702@synaptics.com>
Date: Tue, 4 Feb 2014 12:20:09 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 00/05] input: RMI4 Synaptics RMI4 Touchscreen Driver
References: <1358557965-29065-1-git-send-email-cheiny@synaptics.com> <CACRpkdbf6YGdSC6sWuzfFkzYq99jjFbgB=uBFgBh-jK9H66gPg@mail.gmail.com>
In-Reply-To: <CACRpkdbf6YGdSC6sWuzfFkzYq99jjFbgB=uBFgBh-jK9H66gPg@mail.gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 11:56 PM, Linus Walleij wrote:
> On Sat, Jan 19, 2013 at 2:12 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
>
>> This patchset implements changes based on the synaptics-rmi4 branch of
>> Dmitry's input tree.
>
> What is happening to the RMI4 driver stuff?
>
> Has this development stalled? The branch in Dmitry's git
> seems to be maintained but not much is happening or is
> there any progress?

Hi Linus,

Development stalled for several months last year, but picked up again 
last fall.  We've been submitting patches against Dmitry's input tree, 
sending them to linux-input rather than linux-kernel.  If you check the 
linux-input archives on spinics, you can see what's been going on.

If you'd like, we'll make sure to cc you on upcoming patches.  I've got 
some due - hopefully later today.

					Chris

