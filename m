Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3CGURJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:17:09 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:44372 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3CGURI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:17:08 -0500
References: <20130222111521.GA25473@pd.tnic> <1361647210-12983-1-git-send-email-bp@alien8.de> <20130224112851.GA19609@pd.tnic> <cone.1361706175.908398.1806.1000@galar> <20130224143452.GE19609@pd.tnic> <1361762514.2303.21.camel@rzhang1-mobl4> <20130225102526.GB12067@pd.tnic> <20130225121608.GC12067@pd.tnic> <20130304133410.GC22274@pd.tnic>
Message-ID: <cone.1362687423.847750.1921.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Andreas Mohr <andi@lisas.de>, Zhang Rui <rui.zhang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Date: Thu, 07 Mar 2013 21:17:03 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Borislav Petkov writes:

> On Mon, Feb 25, 2013 at 01:16:08PM +0100, Borislav Petkov wrote:
>> On Mon, Feb 25, 2013 at 11:25:26AM +0100, Borislav Petkov wrote:
>> > > has anybody checked if the patch at lkml.org/lkml/2012/12/30/47 fixes
>> > > the problem, without any other patch?
>> > 
>> > Ok, let me try it out.
>> 
>> Ok, doing a short test here proves successful. I'll run it the next days
>> too to make sure - it would be nice if people could confirm my test
>> results, though.
>> 
>> Tested-by: Borislav Petkov <bp@suse.de>
> 
> Pjooiiing!
> 
> Andreas, Peter, can you guys give http://lkml.org/lkml/2012/12/30/47 a run?

Finally I found some time to do a test run. I did a git clone on the Linus 
tree. But I was not able to apply this patch, seems like it has already been 
applied on mainline.

Anyhow, with current git state acerhdf works flawlessly for me. I tried 
standard usage of the netbook and suspend.

Thanks.

-- 
kind regards,
--peter;
