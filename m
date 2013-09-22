Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3IVTwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 15:52:18 -0400
Received: from plane.gmane.org ([80.91.229.3]:59262 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab3IVTwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 15:52:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Would an "information module" be useful?
Date: Sun, 22 Sep 2013 21:51:49 +0200
Message-ID: <523F4A55.3090106@web.de>
References: <l1n80j$ofi$1@ger.gmane.org> <CAFLxGvweL_O16TwvERsMSwf1UPa5BFwSyFNNRu6Z1CD4ExZXSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: f048038158.adsl.alicedsl.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
In-Reply-To: <CAFLxGvweL_O16TwvERsMSwf1UPa5BFwSyFNNRu6Z1CD4ExZXSg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why can't you use /proc/cmdline?

Thanks for your suggestion.


> (see parse_proc_cmdline())

How do you think about reasons like the following?

1. I would prefer to avoid the repeated parsing of boot command-line parameters
because the reuse of the kernel infrastructure should be better here.

2. Documentation
   Module parameters can also be explained in the source files.
   http://tldp.org/LDP/lkmpg/2.6/html/x323.html

3. Is a corresponding check for specific data types "nice"?
   http://www.linux-magazin.de/Ausgaben/2004/05/Kern-Technik/%28offset%29/2



How are the chances to clarify this implementation detail: In which subdirectory
should a kernel module be stored if it will not manage any hardware?

Regards,
Markus

