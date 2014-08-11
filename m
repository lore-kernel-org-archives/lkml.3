Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaHKOvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:51:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52572 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbaHKOvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:51:05 -0400
Message-ID: <53E8D81E.7050705@zytor.com>
Date: Mon, 11 Aug 2014 07:50:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
References: <20140809231911.GA4843@khazad-dum.debian.net> <20140811102245.GC4236@nazgul.tnic> <20140811131613.GA4541@khazad-dum.debian.net> <20140811140057.GA21693@pd.tnic>
In-Reply-To: <20140811140057.GA21693@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 07:00 AM, Borislav Petkov wrote:
>>
>> I often wonder how much of the Intel SDM is really a fairy tale...  it
>> certainly has enough legends from times long past inside ;-)  But just like
>> old stories, should you forget all about them, they sometimes grow fangs
>> back and get you when you're least prepared.
>>
> 
> It seems to me you're looking for issues where there are none. We simply
> have to ask Intel people what's with the 16-byte alignment and fix
> the SDM, apparently. If the processor accepts the non-16-byte-aligned
> update, why do you care?
> 

The SDM is the contract between the hardware and the software.  This
doesn't mean that not following the SDM doesn't work, but following the
procedure in the SDM is what his guaranteed to work.

So Henrique is right, we should fix this if we can.

	-hpa

