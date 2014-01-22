Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaAVMH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:07:29 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42452 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaAVMH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <20140121204803.GA853@earth.universe>
References: <1389393286-15263-1-git-send-email-sre@debian.org>
	<1389401268-15069-1-git-send-email-sre@debian.org>
	<20140121204803.GA853@earth.universe>
Date: Wed, 22 Jan 2014 16:07:25 +0400
Message-ID: <CALT56yOZ5qCoS-xwFV7sqE1LATQUFckOkQa7dd24Foq7A4Xv2g@mail.gmail.com>
Subject: Re: [PATCHv3] dt: binding documentation for bq2415x charger
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Sebastian Reichel <sre@ring0.de>
Cc: Anton Vorontsov <anton@enomsg.org>,
        kernel list <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 22, 2014 at 12:48 AM, Sebastian Reichel <sre@ring0.de> wrote:
> Hi Dmitry,
>
>> Add devicetree binding documentation for bq2415x charger.
>>
>> Signed-off-by: Sebastian Reichel <sre@debian.org>
>> Acked-by: Pavel Machek <pavel@ucw.cz>
>
> I've seen, that you just sent a pull request for the power supply
> tree. Can you please add this patch [0] and send another pull
> request? It should go into the kernel together with the bq2415x DT
> support patch!

If that is fine with you, I will add this to a 'fixes' branch and send
a pull request
somewhere near -rc2/-rc3. Agreed?

>
> [0] http://www.spinics.net/lists/devicetree/msg18023.html

-- 
With best wishes
Dmitry
