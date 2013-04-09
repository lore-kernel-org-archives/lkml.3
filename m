Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937590Ab3DIKXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:23:21 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41547 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935573Ab3DIKXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:23:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130409101343.GT24058@zurbaran>
References: <1365068715-15868-1-git-send-email-sachin.kamat@linaro.org>
	<20130409101343.GT24058@zurbaran>
Date: Tue, 9 Apr 2013 15:53:19 +0530
Message-ID: <CAK9yfHz+Hg8M0VDErf9umLmE0eemQ114at67wfh9NQVSeCpCYQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: omap-usb-host: Convert to devm_ioremap_resource()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 9 April 2013 15:43, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Sachin,
>
> On Thu, Apr 04, 2013 at 03:15:14PM +0530, Sachin Kamat wrote:
>> Use the newly introduced devm_ioremap_resource() instead of
>> devm_request_and_ioremap() which provides more consistent error handling.
>>
>> devm_ioremap_resource() provides its own error messages; so all explicit
>> error messages can be removed from the failure code paths.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/mfd/omap-usb-host.c |    9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
> The 2 patches make sense to me, but they don't apply cleanly on top of
> mfd-next. Would you mind sending me a rebased version ?

Sure, I will.


-- 
With warm regards,
Sachin
