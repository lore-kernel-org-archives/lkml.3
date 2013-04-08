Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170Ab3DHOox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:44:53 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:13121 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965147Ab3DHOov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:44:51 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 10:44:51 EDT
Message-ID: <5162D5D5.9080906@itdev.co.uk>
Date: Mon, 08 Apr 2013 15:36:05 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk> <20130329164841.GA2230@polaris.bitmath.org>
In-Reply-To: <20130329164841.GA2230@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg wrote:
>> Most of my focus in working on these changes has been to support Atmel's
>> customers, who tend not to be using the mainline kernel. Unfortunately this 
>> has generated somewhat of a backlog in getting these improvements into
>> mainline. My current focus is to get these improvements upstream and I have
>> time allocated to make any alterations as necessary. Since the scope of this
>> patchset is so large any upstream delta tends to cause a big rebasing effort.
>> I would suggest that I merge any useful improvements from the other patchsets
>> to make a combined patchset.
> 
> Are you planning to submit a version for 3.9? If you do, please
> consider sending a smaller set.

My goal is to try and get our changes into 3.10, we still have a couple of
bugs to shake out (unfortunately in the bootloading code, which is at the
front of the series), I will post an updated series once I have resolved that.

You can see the WIP here:
https://github.com/ndyer/linux/commits/for-next
