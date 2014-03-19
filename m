Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbaCSIOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:14:52 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45578 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaCSIOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140318123959.GT11706@sirena.org.uk>
References: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
	<1395138184-25287-2-git-send-email-sachin.kamat@linaro.org>
	<20140318123959.GT11706@sirena.org.uk>
Date: Wed, 19 Mar 2014 13:44:48 +0530
Message-ID: <CAK9yfHzr1+G80rrWyThFMuc3DFW4xsVGsDKhJmZrzycN6T-5Cg@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: max8660: Silence checkpatch warnings
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 18:09, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Mar 18, 2014 at 03:53:02PM +0530, Sachin Kamat wrote:
>> Silences the following type of error/warnings:
>> ERROR: that open brace { should be on the previous line
>> WARNING: Missing a blank line after declarations
>
> Applied, but...
>
>> -     static const u8 max8660_addresses[MAX8660_N_REGS] =
>> -       { 0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };
>> +     static const u8 max8660_addresses[MAX8660_N_REGS] = {
>> +       0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };
>
> Think about what you're doing here - you want the }; on a new line too.

Sorry about it. I was kind of in two minds about shifting it. I will
send a followup
for completeness.


-- 
With warm regards,
Sachin
