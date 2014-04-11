Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422836AbaDKA0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:26:04 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:52553 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422786AbaDKA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+4SztwyrmMtN31Vof3Tb8U9VVpLs1uON5W=VVOpX=nUQ@mail.gmail.com>
References: <CAMuHMdUmcnzafPhWrp4qYBB3UniFbVtqzNNg-7ed_Q6hZKMeDw@mail.gmail.com>
	<1394234910-8547-1-git-send-email-florian.vaussard@epfl.ch>
	<CAL_Jsq+4SztwyrmMtN31Vof3Tb8U9VVpLs1uON5W=VVOpX=nUQ@mail.gmail.com>
Date: Thu, 10 Apr 2014 19:25:59 -0500
Message-ID: <CAL_JsqLiAF916KvHDgRu2df0qbkYAUL51BFq-62z50xfzZOr-g@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: dt: Reduce fragmentation of <..> placeholders
From: Rob Herring <robherring2@gmail.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Perches <joe@perches.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 3:09 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Mar 7, 2014 at 5:28 PM, Florian Vaussard
> <florian.vaussard@epfl.ch> wrote:
>> Placeholders <..> are sometimes used in the devicetree documentation
>> to define family-wide compatible strings (like fsl,<chip>-ipu where
>> chip can be any Freescale SoC).
>>
>> These placeholders are loosly defined. This lead to some
>> fragmentation. Looking at the current placeholders, we have:
>>
>>       3 <board>
>>      32 <chip>
>>       1 <chip name>
>>       1 <mcu-chip>
>>       1 <processor>
>>      30 <soc>
>>       1 <SOC>
>>       1 <soc-family>
>>
>> This patch consolidates this to:
>>
>>       3 <board>
>>      33 <chip>
>>       1 <mcu-chip>
>>       1 <processor>
>>      32 <soc>
>>
>
> I would prefer to consolidate these into just board and chip. If we
> have any oddballs, they can just document the exact strings.

Florian, Do you plan to re-spin this? I can take it for 3.15 if it is
early in the rc's.

Rob
