Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab3BXLn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:43:56 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:39632 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3BXLnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:43:55 -0500
References: <20130222111521.GA25473@pd.tnic> <1361647210-12983-1-git-send-email-bp@alien8.de> <20130224112851.GA19609@pd.tnic>
Message-ID: <cone.1361706175.908398.1806.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Date: Sun, 24 Feb 2013 12:42:55 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

thanks for your best wishes in the last mail, I'm feeling little better now.

Borislav Petkov writes:

> On Sat, Feb 23, 2013 at 08:20:10PM +0100, Borislav Petkov wrote:
>> From: Borislav Petkov <bp@suse.de>
>> 
>> The new step_wise thermal governor wasn't able to handle the one-trip
>> point design of acerhdf where we want to turn off the fan if we go under
>> the 'fanoff' temperature and to turn it on only after exceeding the
>> 'fanon' temperature.
>> 
>> Do that by looking at the current fan state and return the temperature
>> accordingly.
>> 
>> Suggested-by: Zhang Rui <rui.zhang@intel.com>
>> Cc: Peter Feuerer <peter@piie.net>
>> Cc: Andreas Mohr <andi@lisas.de>
>> Cc: Alexander Lam <azl@andrew.cmu.edu>
>> Signed-off-by: Borislav Petkov <bp@suse.de>
> 
> Ok, ignore this one for now - the suspend/resume path doesn't pan out
> somehow, need to do some more handholding here.

Please test my last patch with the 4 trip points ;) - even if you don't 
really like it, it is working great! - And to be honest, I still prefer this 
solution!

Anyhow, did you test what Rui asked us to test?

-- 
kind regards,
--peter;
