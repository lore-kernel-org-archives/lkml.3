Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaETRqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:46:48 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:49649 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaETRqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140520100252.GA16428@pd.tnic>
References: <1400328343-6483-1-git-send-email-slaoub@gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3280E51C@ORSMSX114.amr.corp.intel.com>
	<20140519181524.GC6311@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F3280EA8A@ORSMSX114.amr.corp.intel.com>
	<20140520100252.GA16428@pd.tnic>
Date: Tue, 20 May 2014 10:46:44 -0700
Message-ID: <CA+8MBb+rqmx+_bL2j6NA2SsGPrVok4xqJqDnjknKupXOgSsJGA@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Clear a useless global variable in mce.c
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chen Yucong <slaoub@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 3:02 AM, Borislav Petkov <bp@alien8.de> wrote:
>> I'm OK with it going - but as I said before I'd like to see mce_callin
>> printed (so I can tell if just one cpu showed up, just the cpus from
>> one socket, or some other significant number).
>
> I don't think you want to do this unconditionally, do you? Rather maybe
> mce_timed_out dumps the order variable before the box panics :-)

Agreed - not unconditionally - just when we have a problem. Dumping
"order" in the timeout case would be a good place.

-Tony
