Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3AQQfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:35:03 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63933 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab3AQQfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:35:01 -0500
Message-ID: <50F82830.8070603@suse.cz>
Date: Thu, 17 Jan 2013 17:34:56 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>, Florian Westphal <fw@strlen.de>,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
References: <20130110144626.GA26279@breakpoint.cc> <20130110155058.12f66e73@bob.linux.org.uk> <20130110162907.GB26279@breakpoint.cc> <50EEF8FD.9000004@suse.cz> <20130110224554.1724a791@bob.linux.org.uk> <50EF45DF.4010905@suse.cz> <50EFF366.2000303@suse.cz> <20130111124129.GA23516@breakpoint.cc> <50F00926.3070000@suse.cz> <20130111131802.2986ba61@bob.linux.org.uk> <20130117162924.GC1396@kroah.com>
In-Reply-To: <20130117162924.GC1396@kroah.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 05:29 PM, Greg KH wrote:
> On Fri, Jan 11, 2013 at 01:18:02PM +0000, Alan Cox wrote:
>> IMHO - fix now for the -rc tree where its clearly low risk, after that
>> whatever people feel like doing 8)
> 
> I agree.  Jiri, should I take your posted patch for this?

Yeah, I think it's just fine as the fix.

thanks,
-- 
js
suse labs
