Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaHDAYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:24:24 -0400
Received: from s87.loopia.se ([194.9.94.112]:64258 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbaHDAYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:24:22 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <53DED2E9.5090205@hanshq.net>
Date: Sun, 03 Aug 2014 17:25:13 -0700
From: Hans Wennborg <hans@hanshq.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
        linux-cifs@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] cris: fix %d confusingly prefixed with 0x in format
 string
References: <1407018043-648-1-git-send-email-hans@hanshq.net>	 <1407026806.1835.21.camel@joe-AO725> <53DD8E17.1@hanshq.net> <1407046215.1835.24.camel@joe-AO725>
In-Reply-To: <1407046215.1835.24.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 11:10 PM, Joe Perches wrote:
> On Sat, 2014-08-02 at 18:19 -0700, Hans Wennborg wrote:
>> Yes, I have a patch for a bunch of these, but I figured it would be
>> easier to get it merged if I split it up. (Complete kernel newbie here.)
>
> You as a kernel newbie did good, thanks.
>
> A small tip would be to do all of them in a single series
> cc'ing each individual patch to the appropriate maintainers
> and mailing lists.

Thanks for the advice! I have split up and sent out the big patch as a 
series, with hopefully the right folks CC'd.

  - Hans
