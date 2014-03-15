Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaCOToH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 15:44:07 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:34595 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaCOToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 15:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140315123331.7351DC40A1B@trevor.secretlab.ca>
References: <1394817109-26199-1-git-send-email-grant.likely@linaro.org>
	<CAL_JsqLtYFiLnLgdN_GMG33JD53wFdyfhCwLHek3tLBbQB7maQ@mail.gmail.com>
	<20140315123331.7351DC40A1B@trevor.secretlab.ca>
Date: Sat, 15 Mar 2014 14:44:02 -0500
Message-ID: <CAL_JsqLxexGWALTVb4BEzqpxj_iOnrHA3XtRNxbP1HRSOJeByg@mail.gmail.com>
Subject: Re: [RFC v3 3/3] of: Make of_find_node_by_path() handle /aliases
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 7:33 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Fri, 14 Mar 2014 16:39:38 -0500, Rob Herring <robherring2@gmail.com> wrote:
>> On Fri, Mar 14, 2014 at 12:11 PM, Grant Likely <grant.likely@linaro.org> wrote:
>> > Make of_find_node_by_path() handle aliases as prefixes. To make this
>> > work the name search is refactored to search by path component instead
>> > of by full string. This should be a more efficient search, and it makes
>> > it possible to start a search at a subnode of a tree.
>> >
>> > Signed-off-by: David Daney <david.daney@cavium.com>
>> > Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> > [grant.likely: Rework to not require allocating at runtime]
>> > Signed-off-by: Grant Likely <grant.likely@linaro.org>
>>
>> I should have read the comments before trying to figure out why you
>> had that "pointless" recursion...
>
> Hi Rob,
>
> Thanks for the review. However, I'm a little slow this morning and I
> don't understand what you mean. Did I miss an early comment?

No, it's me that was being slow. At first glance I was thinking the
recursion was pointless until I saw the alias + path case.

Rob
