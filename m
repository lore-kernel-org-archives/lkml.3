Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3AYWPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:15:54 -0500
Received: from mailgw1.ericsson.se ([193.180.251.45]:52313 "EHLO
	mailgw1.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3AYWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:15:52 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 17:15:52 EST
X-AuditID: c1b4fb2d-b7f316d0000028db-58-510300920931
Date: Fri, 25 Jan 2013 17:00:48 -0500
To: Jerry Snitselaar <dev@snitselaar.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [ 11/15] ahci: Add identifiers for ASM106x devices
Message-ID: <20130125220048.GA7238@dolphin.nala.lmc.ericsson.se>
References: <20130124211723.489089115@linuxfoundation.org> <20130124211727.847446491@linuxfoundation.org> <20130125204521.GA1637@cantor.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130125204521.GA1637@cantor.Home>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Abdallah Chatila <abdallah.chatila@ericsson.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsUyM+Jvre4kBuZAgzPn+S0uPL/AYrF6/REW
	ix1rv7BbNC9ez2axtOENq8XlXXPYLBZsfMTowO4x72Sgx/65a9g9Wk9uYvV4v+8qm8eb/ZcZ
	PT5vkgtgi+KySUnNySxLLdK3S+DKmHfsC1vBIuaKVT8/sjcwnmDqYuTkkBAwkfjb9ZcFwhaT
	uHBvPVsXIxeHkMBJRol/Z1YyQziLGSWWLl/DClIlJJAusffxRmYQm0VAVWLy9mWMILaIgKZE
	+4qXYHFmgTOMEl2TpUFsYQF7iaMtnWDbeAUcJN4/vQ21oZdR4vrsR1AJQYmTM5+wQDTrSCzY
	/QmoiAPIlpZY/o8DJMwpYCAx6+QuNhBbVEBF4tPriewgNpuAmcSVnvvMELdpSVyY2coygVFo
	FpKps5BMnYUwdQEj8ypG9tzEzJz0csNNjMAIOLjlt+4OxlPnRA4xSnOwKInzhrleCAB6OLEk
	NTs1tSC1KL6oNCe1+BAjEwenVANjxOlnu2d/N0q++/bCCUGTAGbxQJFa+cNxPOILBWrK/hir
	byuJaoz4sur5AVnVQx+txCvun9JWfl3iXGI+s1xl4szspRYr2V5fXtulzqumVua4oW77vj3R
	ZzRWvj/Loi2R2K5lZi3Wu4DrxZv0D9N2/Ns7+3R44PITVs8f80t+fazbNl/c8J6cEktxRqKh
	FnNRcSIAzwrMTk4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 01:45:21PM -0700, Jerry Snitselaar wrote:
> 
> There is a whitespace error in this patch:
> 
> Applying: ahci: Add identifiers for ASM106x devices
> /root/linux/linux/.git/rebase-apply/patch:12: space before tab in indent.
>         /* Asmedia */
> warning: 1 line adds whitespace errors.

Will send a new patch to remove the extra whitespace before the comment
shortly.


Thanks
