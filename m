Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab3FSGuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:50:15 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:60146 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3FSGuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:50:12 -0400
Message-ID: <51C154A0.6080104@suse.cz>
Date: Wed, 19 Jun 2013 08:50:08 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jeff Mahoney <jeffm@suse.com>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-usb@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Michal Marek <mmarek@suse.cz>, tomi.valkeinen@ti.com
Subject: Re: [PATCH] build some drivers only when compile-testing
References: <1369214326-6558-1-git-send-email-jslaby@suse.cz> <20130523022327.GB6159@kroah.com> <519D8876.9050405@suse.com> <51BF6BFF.7050705@suse.cz> <20130618160427.GE28961@kroah.com>
In-Reply-To: <20130618160427.GE28961@kroah.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 06:04 PM, Greg Kroah-Hartman wrote:
>> So currently I have what is attached... Comments?
> 
> Looks good to me, want me to queue it up through my char/misc driver
> tree for 3.11?

If there are no objections... Whoever picks that up, I would be happy 8-).

-- 
js
suse labs
