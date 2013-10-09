Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3JIREy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:04:54 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:38874 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3JIREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <52539B4C.9040400@synopsys.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
	<1381163377-21044-26-git-send-email-robherring2@gmail.com>
	<52539B4C.9040400@synopsys.com>
Date: Wed, 9 Oct 2013 12:04:52 -0500
Message-ID: <CAL_JsqJS8Vwt2363BXP+3zVNAHM-H=JPKEMkaq22wuQJBCZUXw@mail.gmail.com>
Subject: Re: [PATCH v2 25/29] arc: use common of_flat_dt_match_machine
From: Rob Herring <robherring2@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 12:42 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> Hi Rob,
>
> On 10/07/2013 09:59 PM, Rob Herring wrote:
>> From: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>
>>
>> Convert arc to use the common of_flat_dt_match_machine function.
>>
>> Signed-off-by: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>
>> Acked-by: Vineet Gupta <vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>

>
> Can you please fold the following into this patch. This removes the const warning
> and also gets rid of some dead code.

Thanks. I've added this in and updated my branch. Please double check
it when you have a chance. I also made __arch_info_begin[] and
__arch_info_end[] const.

Rob
