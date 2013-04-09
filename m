Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936663Ab3DIApV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 20:45:21 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55751 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936517Ab3DIApU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 20:45:20 -0400
Message-ID: <5163649C.1010003@gmail.com>
Date: Mon, 08 Apr 2013 17:45:16 -0700
From: Tyrel Datwyler <turtle.on.the.radio@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "edubezval@gmail.com" <edubezval@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: omap-thermal: remove trailing whitespace from
 omap-bandgap.c
References: <1365385640-10443-1-git-send-email-turtle.on.the.radio@gmail.com> <20130408172233.GA26206@kroah.com> <CAC-25o9wUGRAjaO1jEbRB9AdwT7sgGcH2M2oyh4-rSyoCiSm7Q@mail.gmail.com> <51630C01.6010601@ti.com>
In-Reply-To: <51630C01.6010601@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 11:27 AM, Eduardo Valentin wrote:
>
> Thanks for your patch. But as mentioned by Greg, this file does not
> exist anymore, it has been renamed. Check latest linux-next.
>
> Besides, the issue you are fixing has been already removed. Also check
> latest linux-next and you will see the driver under:
> drivers/staging/ti-soc-thermal/ti-bandgap.c
>
> Thanks, please keep sending your patches and copy my email address so I
> will give you a quick response.
>

So, what you guys are telling me is that linux-next and not Linus's tree 
is where the action is at? I was looking for something trivial as a test 
run through the submission process, and I still managed to botch it. 
Noted and lesson learned.

-Tyrel
