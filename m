Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3AJWvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:51:18 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38064 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3AJWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:51:15 -0500
Message-ID: <50EF45DF.4010905@suse.cz>
Date: Thu, 10 Jan 2013 23:51:11 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, gregkh@linuxfoundation.org,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
References: <20130110144626.GA26279@breakpoint.cc> <20130110155058.12f66e73@bob.linux.org.uk> <20130110162907.GB26279@breakpoint.cc> <50EEF8FD.9000004@suse.cz> <20130110224554.1724a791@bob.linux.org.uk>
In-Reply-To: <20130110224554.1724a791@bob.linux.org.uk>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 11:45 PM, Alan Cox wrote:
> So we should just fix TIOCGPTN on a pty with no suitable name answer to
> return -EINVAL

Yes, I agree as I'm expressed in my second mail. Sorry for the confusion.

-- 
js
suse labs
