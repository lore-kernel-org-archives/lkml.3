Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3EVIus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:50:48 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:52058 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3EVIuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:50:44 -0400
Message-ID: <519C8704.6060901@suse.cz>
Date: Wed, 22 May 2013 10:51:16 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jirislaby@gmail.com
CC: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 13/15] chipidea: Allow user to select PCI/IMX options
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz> <1367936303-13386-13-git-send-email-jslaby@suse.cz> <87k3n9n8ln.fsf@ashishki-desk.ger.corp.intel.com> <5193B0CB.9080608@suse.cz> <87a9nvl10l.fsf@ashishki-desk.ger.corp.intel.com>
In-Reply-To: <87a9nvl10l.fsf@ashishki-desk.ger.corp.intel.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 11:36 AM, Alexander Shishkin wrote:
> The benefit from compiling it on non-arm (or non-imx) architectures for
> me is compilation testing. We don't have a whole lot of architectures
> with CONFIG_OF so it's nice to give it a stretch.

Yes, the newly added COMPILE_TEST config option will do the job. Stay
tuned...

> If you really want to save space in your rpm package, I would suggest
> you add a condition to Makefile (ifeq ($(ARCH),arm) or something like
> that) instead of a Kconfig option. I would prefer at least to avoid the
> unnecessary kconfig option creep.

Uhuh, why should *users* patch the kernel prior building it with
allmodconfig? We do not want to carry *any* patches with our kernels.

thanks,
-- 
js
suse labs
