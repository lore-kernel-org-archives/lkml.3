Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3AJUNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:13:46 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59271 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3AJUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:13:44 -0500
Message-ID: <50EF20F4.5060503@suse.cz>
Date: Thu, 10 Jan 2013 21:13:40 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Florian Westphal <fw@strlen.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        gregkh@linuxfoundation.org, frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
References: <20130110144626.GA26279@breakpoint.cc> <20130110155058.12f66e73@bob.linux.org.uk> <20130110162907.GB26279@breakpoint.cc> <50EEF8FD.9000004@suse.cz>
In-Reply-To: <50EEF8FD.9000004@suse.cz>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 06:23 PM, Jiri Slaby wrote:
> getptsname expects EINVAL on failure to fall back to /dev/ttyp*... The
> same as unlockpt. We should definitely revert now

Maybe not that strictly. It would be enough to revert TIOCGPTN and
TIOCSPTLCK to return EINVAL as suggested by Alan.
-- 
js
suse labs
