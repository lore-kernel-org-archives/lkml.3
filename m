Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3EaJbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:31:09 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52483 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab3EaJbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:31:02 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8sf-SVKiw6wjazV3VRd78efOU9qTO_qtr3RbOtrTifwgw@mail.gmail.com>
References: <1367906651-5058-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8sf-SVKiw6wjazV3VRd78efOU9qTO_qtr3RbOtrTifwgw@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 31 May 2013 15:00:41 +0530
Message-ID: <CA+V-a8us-dzX4BGzWOO0AbBxVCv-9LpitEgzFgNtx3uStj4R0w@mail.gmail.com>
Subject: Re: [PATCH] of/base: fix typos
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, May 23, 2013 at 5:58 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Rob/Grant,
>
> On Tue, May 7, 2013 at 11:34 AM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> the function of_property_read_u8/16/32_array() has a parameter
>> out_values, but the description mentioned it as out_value. This
>> patch fixes this typo.
>>
Can you pick this patch ?

Regards,
--Prabhakar Lad
