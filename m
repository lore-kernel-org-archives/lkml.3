Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3CNGph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:45:37 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54122 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3CNGpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:45:35 -0400
MIME-Version: 1.0
In-Reply-To: <1362416898.24058.1.camel@gitbox>
References: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
	<1362416898.24058.1.camel@gitbox>
Date: Thu, 14 Mar 2013 12:15:34 +0530
Message-ID: <CAK9yfHwoBoqOuw0ACnBoVSFGr8ubkeUVATrBaDma0sLLQoh-1w@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio/vt8500: Convert to devm_ioremap_resource()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 4 March 2013 22:38, Tony Prisk <linux@prisktech.co.nz> wrote:
> On Mon, 2013-03-04 at 14:39 +0530, Sachin Kamat wrote:
>> Use the newly introduced devm_ioremap_resource() instead of
>> devm_request_and_ioremap() which provides more consistent error handling.
>>
>> devm_ioremap_resource() provides its own error messages; so all explicit
>> error messages can be removed from the failure code paths.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

> Acked-by: Tony Prisk <linux@prisktech.co.nz>

Would you be picking this patch up or Grant is gonna handle it?


-- 
With warm regards,
Sachin
