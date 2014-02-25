Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBYKMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:12:10 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:36426 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaBYKMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:12:07 -0500
MIME-Version: 1.0
In-Reply-To: <530C6BD2.5090209@epfl.ch>
References: <CAK9yfHyAK+LtQLr_b-OLHa63dSNT5KN7MBHxqVoTbiHVb4-7DA@mail.gmail.com>
	<1393318071-13524-1-git-send-email-philippe.retornaz@epfl.ch>
	<CAK9yfHx9FnQxQOmHcMzc8dQa+mSryPRo=63FL=8tg1JGqe4jNQ@mail.gmail.com>
	<530C6BD2.5090209@epfl.ch>
Date: Tue, 25 Feb 2014 15:42:07 +0530
Message-ID: <CAK9yfHyXot3xrOYkWum45tykq1Sb+3sHdoM_JePTpeOeURVTbg@mail.gmail.com>
Subject: Re: [PATCH 1/1] regulator: mc13xxx: check if DT is enabled
From: Sachin Kamat <sachin.kamat@linaro.org>
To: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2014 15:39, Philippe Rétornaz <philippe.retornaz@epfl.ch> wrote:
> Le 25/02/2014 10:12, Sachin Kamat a écrit :
>
>> On 25 February 2014 14:17, Philippe Rétornaz <philippe.retornaz@epfl.ch>
>> wrote:
>>
>> Thanks for the patch. I was about to send a similar patch which also
>> does a little more cleanup.
>> If you could test it in DT and non-DT modes that would be great. I
>> attach the diff below. You can
>> even fold it into your patch if you wish.
>
>
> It does fix the regression on the non-DT board.
> I don't have any DT-enabled board with mc13xxx PMIC so I cannot test the
> DT case. I will let you test the DT case & submit the final patch.

Thanks for the confirmation. I will post this patch.

-- 
With warm regards,
Sachin
