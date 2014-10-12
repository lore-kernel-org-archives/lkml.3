Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaJLRmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:42:24 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48365 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbaJLRmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:42:23 -0400
Message-ID: <543ABD7D.5010308@hurleysoftware.com>
Date: Sun, 12 Oct 2014 13:42:21 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CRASH during boot 3.16.3+
References: <543A88E4.4060707@xs4all.nl>
In-Reply-To: <543A88E4.4060707@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2014 09:57 AM, Udo van den Heuvel wrote:
> Hello,
> 
> 3.16.2 boots and works fine.
> Kernels 3.16.3 and newer crash very early during boot. (did not yet try
> 3.17)
> 
> The problem:
> During the first few seconds of bootup the kernel gets into some sort of
> loop and rapidly prints loads of register-like things and then a load of
> rubbish.
> I did `make clean` and then a rebuild etc but this did not help.
> 
> How can I capture the logging to find the point where things go wrong?
> How can I find out what is wrong?

Start with git bisect between good=3.16.2 and bad=3.16.3.
And dmesg from 3.16.2.

What happens after the 'then a load of rubbish.'? And rubbish is not
very descriptive. Please include a sample, if you can't catch all the
console prints.


Regards,
Peter Hurley

