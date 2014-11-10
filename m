Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaKJOTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:19:18 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36811 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaKJOTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:19:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141109091932.GJ2722@sirena.org.uk>
References: <1415448772-3895-1-git-send-email-badarkhe.manish@gmail.com>
	<20141109091932.GJ2722@sirena.org.uk>
Date: Mon, 10 Nov 2014 19:49:16 +0530
Message-ID: <CAKDJKT5yKp-JyGEsOjcQ=bxd6OddQqZgx0E8s2k=i-jHj9nRHA@mail.gmail.com>
Subject: Re: [PATCH] regulator: tps65218: Remove '.owner' field
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Nov 9, 2014 at 2:49 PM, Mark Brown <broonie@kernel.org> wrote:
> On Sat, Nov 08, 2014 at 05:42:52PM +0530, Manish Badarkhe wrote:
>> Remove '.owner' field of driver structure as it is
>> going to be filled via "module_platform_driver" call.
>
> Same question as ever with this stuff: if we've decided to do this why
> are we doing it for a single driver and not as a genric cleanup?

There are many drivers needs to be changed with such fix.
Can we fix drivers with this fix module by module or all at once?
Please let me know your opinion.

Thanks
Manish Badarkhe
