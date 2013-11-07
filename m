Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3KGNmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:42:18 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44042 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab3KGNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:42:15 -0500
X-Sasl-enc: OtYfm7v3MGckWCCBNZX117Mk+lKG2Mi0p7txBtzrhbCX 1383831728
Date: Thu, 7 Nov 2013 11:42:04 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        X86 ML <x86@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: kernel bugzilla #64531: intel microcode information
Message-ID: <20131107134204.GC3355@khazad-dum.debian.net>
References: <527B28BB.9070400@infradead.org>
 <201311070943.40134.a.miskiewicz@gmail.com>
 <20131107090325.GB403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107090325.GB403@gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Nov 2013, Ingo Molnar wrote:
> How about:
>   http://www.intel.com/content/www/us/en/search.html?keyword=linux+microcode+data+file
> 
> ? That, by the looks of it, appears to be a reasonably stable URL.

But it is also mostly useless.  No version information in the results, and
the newest one is NOT the topmost, either.

This one is better, in that it at least has the required information, but
your browser needs to have a proper built-in RSS renderer:
http://feeds.downloadcenter.intel.com/rss/?p=483&lang=eng

You might want to use the URL for a newer processor family, though.
E.g. for the 5000-sequence Xeons:
http://feeds.downloadcenter.intel.com/rss/?p=2371&lang=eng

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
