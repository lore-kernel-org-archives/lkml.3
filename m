Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab3JAQcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:32:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53609 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3JAQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <524AEF0E.6090207@wwwdotorg.org>
References: <1380600664-20649-1-git-send-email-badarkhe.manish@gmail.com>
	<20131001092258.GJ19304@sirena.org.uk>
	<CAKDJKT6kBi_axtn+qDBkwueRGn_zzOAdSstRF=x1OqX-TrO2XQ@mail.gmail.com>
	<524AEF0E.6090207@wwwdotorg.org>
Date: Tue, 1 Oct 2013 22:02:37 +0530
Message-ID: <CAKDJKT7m0d=GqFF_QTOQitBRac=UZYEaZi5L1xEggM-cp9c85w@mail.gmail.com>
Subject: Re: [PATCH] regulator: tps65090: remove usage of IS_ERR_OR_NULL
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

Thank you for your reply.

On Tue, Oct 1, 2013 at 9:19 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/01/2013 08:59 AM, Manish Badarkhe wrote:
>> Hi Mark,
>>
>> Thank you for your reply.
>>
>> On Tue, Oct 1, 2013 at 2:52 PM, Mark Brown <broonie@kernel.org> wrote:
>>> On Tue, Oct 01, 2013 at 09:41:04AM +0530, Manish Badarkhe wrote:
>>>> This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
>>>> macro.
>>>
>>> Why?
>>
>> Code use "IS_ERR_OR_NULL()" properly as per current implementation. But
>> as per patches [1], [2] below, the use of "IS_ERR_OR_NULL()" has been
>> deprecated.
>> Hence done this change.
>
> The intent was to deprecate to *concept* of checking a return value for
> both NULL and an error. Simply removing usage of the macro and replacing
> it with the exact same code that was part of the macro doesn't fulfil
> the intent at all.

Ok, Please drop this patch.

Regards
Manish Badarkhe
