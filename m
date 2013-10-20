Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab3JTWS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:18:27 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:55002 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab3JTWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbpRkiANA32ZMEhm-XTB_FKCfmKQuGSmsD_0rLi96kPtQ@mail.gmail.com>
References: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
 <CACRpkdYx07Kfs6zOQmTg2cTSmEmsGgP=7wMCSG_30NW=dfYRPQ@mail.gmail.com>
 <CAAVeFu+rj6AtKgfig6ZrYUzW9HZTg5qLyw4aGozyD31P_pEKAQ@mail.gmail.com> <CACRpkdbpRkiANA32ZMEhm-XTB_FKCfmKQuGSmsD_0rLi96kPtQ@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 20 Oct 2013 15:18:03 -0700
Message-ID: <CAAVeFuJ=Qvj2pT57T88eURrUOFURRFSXrFA+pL4xiA9c5sh9ig@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] New descriptor-based GPIO interface
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 2:26 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Oct 18, 2013 at 7:37 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> On Fri, Oct 18, 2013 at 4:23 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
>>> We might have to take this as the first thing after the merge
>>> window and targeted for v3.14.
>>
>> No particular pressure from my side to get this in 3.13. Do for the
>> best, and don't hesitate to delay them to 3.14 if you feel they are
>> not tested enough. I'll already feel better once I know they are under
>> your tree. ;)
>
> I applied it now anyway, I will try to also apply the ACPI stuff
> making use of this interface and then throw it at the autobuild
> to see what happens.

Autobuild was unfortunately not too happy with one of the patches,
sorry about that. I have sent a small series that addresses the issues
it highlighted. Not sure if you are ok with squashing the first two
into bae48da2, but IMHO that would be the preferred way.

Thanks,
Alex.
