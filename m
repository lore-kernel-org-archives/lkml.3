Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaBIKcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 05:32:13 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:41732 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaBIKcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 05:32:11 -0500
Message-ID: <52F75923.7080400@suse.cz>
Date: Sun, 09 Feb 2014 11:32:03 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: tomas.winkler@intel.com
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        alexander.usyskin@intel.com
Subject: Re: Linux 3.12.10
References: <20140206200036.GA2121@kroah.com>
In-Reply-To: <20140206200036.GA2121@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 09:00 PM, Greg KH wrote:
> Tomas Winkler (1): mei: use hbm idle state to prevent spurious
> resets

Hi,

I'm getting this now:
drivers/misc/mei/hbm.c: In function 'mei_hbm_dispatch':
drivers/misc/mei/hbm.c:596:3: warning: 'return' with a value, in
function returning void

Care to fix that?

thanks,
-- 
js
suse labs
