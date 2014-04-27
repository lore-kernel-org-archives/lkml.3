Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaD0WWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:22:52 -0400
Received: from smtprelay04.ispgateway.de ([80.67.29.8]:57695 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaD0WWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:22:51 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1398561815-22033-2-git-send-email-peter@piie.net> <20140427210321.GA16142@pd.tnic>
Message-ID: <cone.1398637367.408741.1804.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH 1/4] acerhdf: Adding support for
         =?UTF-8?B?Im1hbnVhbCBtb2RlIg==?=
Date: Mon, 28 Apr 2014 00:22:47 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov writes:

> On Sun, Apr 27, 2014 at 03:23:32AM +0200, Peter Feuerer wrote:
>> From: Peter Feuerer <peter@piie.net>
>> 
>> Some Acer models require an additional command to turn off the fan after
>> bios mode has been enabled.  Adding new section in bios table to allow
>> support for those models, by writing an extra "manual mode" register.
> 
> Why?
> 
> That command is always the same AFAICT. So why not add a single flag to
> bios_settings_t called "needs_manual" or such and then do the required
> dance in acerhdf_change_fanstate() if it is set?

I wanted to be prepared for possible upcoming models with changed registers 
/ values.  But I guess it would make sense to go for your proposal for now 
and then afterwards we should discuss about implementing the idea of 
Andreas and split the bios_tbl.


> Btw, this "struct bios_settings_t" could lose that "_t" at the end as it
> is not a typedef. We don't like typedefs anyway. :-)

True, will put this on my todo list :)

-- 
--peter;
