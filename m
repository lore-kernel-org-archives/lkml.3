Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaHDXrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:47:16 -0400
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:43688 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752723AbaHDXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:47:15 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2014 19:47:15 EDT
Message-ID: <53E01A3D.8070504@ramsay1.demon.co.uk>
Date: Tue, 05 Aug 2014 00:41:49 +0100
From: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.1.0-rc1
References: <xmqqy4v3q43r.fsf@gitster.dls.corp.google.com>
In-Reply-To: <xmqqy4v3q43r.fsf@gitster.dls.corp.google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/14 23:31, Junio C Hamano wrote:
> v2.1.0-rc1, the first release candidate Git for v2.1, is now

[snip]

> 
>  * The leaf function to check validity of a refname format has been
>    micro-optimized, using SSE2 instructions when available.  A few
>    breakages during its development have been caught and fixed already
>    but there might remain some more still; please test and report if
>    you find any.

This has been removed.

ATB,
Ramsay Jones



