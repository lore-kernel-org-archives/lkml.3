Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaAMWbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:31:35 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:59323 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAMWbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:31:33 -0500
Subject: Re: [PATCH] Staging: ced1401: fix coding style in ced_ioc.c
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Pol Eyschen <poleyschen@gmail.com>
In-Reply-To: <20140113214429.GH7444@mwanda>
Date: Mon, 13 Jan 2014 23:31:29 +0100
Cc: Mark Einon <mark@einon.net>, devel@driverdev.osuosl.org, jack@suse.cz,
        sachin.kamat@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, ufimtseva@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <CF9619EF-B1AE-4F7D-B080-E5D4B5625474@gmail.com>
References: <1389642100-3601-1-git-send-email-poleyschen@gmail.com> <20140113213552.GA5368@einon.net> <20140113214429.GH7444@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13.01.2014, at 22:44, Dan Carpenter wrote:

> On Mon, Jan 13, 2014 at 09:35:53PM +0000, Mark Einon wrote:
>> On Mon, Jan 13, 2014 at 08:41:40PM +0100, Pol Eyschen wrote:
>>> From: Pol Eyschen <poleyschen@hotmail.com>
>>> 
>>> All comments fixed to match the kernel coding style.
>>> 
>>> Signed-off-by: Pol Eyschen <poleyschen@gmail.com>
>>> ---
>> 
>> This patch doesn't apply to my staging-next branch. Are you making your
>> changes to the staging-next branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git?
>> 

I cloned git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git and made my changes to that branch.

>>> drivers/staging/ced1401/ced_ioc.c |  382 ++++++++++++++++++++++++-------------
>>> 1 file changed, 249 insertions(+), 133 deletions(-)
>>> 
>>> diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
>>> index 62efd74..e5172cb 100644
>>> --- a/drivers/staging/ced1401/ced_ioc.c
>>> +++ b/drivers/staging/ced1401/ced_ioc.c
>>> @@ -41,7 +41,8 @@ static void FlushOutBuff(DEVICE_EXTENSION *pdx)
>>> {
>>> 	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
>>> 		pdx->sCurrentState);
>>> -	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
>>> +	if (pdx->sCurrentState == U14ERR_TIME)
>>> +		/* Do nothing if hardware in trouble */
>>> 		return;
>> 
>> Putting a comment after a single line 'if' and before the statement is
>> not the norm and can be confusing. Please don't do it.
>> 
> The guideline is that multi-line indents should get {} braces for
> readability even though they aren't needed for syntax.
> 
> 	if (pdx->sCurrentState == U14ERR_TIME) {
> 		/* Do nothing if hardware in trouble */
> 		return;
> 	}
> 
I took the original comments that were there, and just formatted them to be in order with the coding style, I didn't add or remove anything. This is my first patch so I didn't want to mess too much with what was there before, even if the comments sometimes seemed superfluous to me.

Pol

