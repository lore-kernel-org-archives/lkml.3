Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3FGOra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:47:30 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:16678 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754280Ab3FGOr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:47:28 -0400
Message-ID: <51B1F27F.7080305@itdev.co.uk>
Date: Fri, 07 Jun 2013 15:47:27 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <1370453866-16534-11-git-send-email-nick.dyer@itdev.co.uk> <20130606180125.GA26084@kroah.com>
In-Reply-To: <20130606180125.GA26084@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jun 05, 2013 at 06:37:03PM +0100, Nick Dyer wrote:
>> Atmel maXTouch chips can be addressed via an "Object Based Protocol" which
>> defines how i2c registers are mapped to different functions within the
>> chips. This interface exposes the register map and allows user-space
>> utilities to inspect and alter object configuration, and to view diagnostic
>> data, while the device is running.
>>
>> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
>> Acked-by: Benson Leung <bleung@chromium.org>
>> ---
>>  drivers/input/touchscreen/atmel_mxt_ts.c |   82 ++++++++++++++++++++++++++++++
>>  1 file changed, 82 insertions(+)
> 
> Whenever you add/remove/modify sysfs files, you also need a
> Documentation/ABI/ update as well.  Please include that.

Will do. I think I should also document the existing sysfs files which are
missing docs.
