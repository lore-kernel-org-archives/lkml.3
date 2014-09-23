Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbaIWUsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:48:45 -0400
Received: from mout.gmx.net ([212.227.15.18]:58926 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbaIWUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:48:44 -0400
Message-ID: <5421DC9F.2080504@gmx.de>
Date: Tue, 23 Sep 2014 22:48:31 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: nick <yocto6@gmail.com>, jejb@parisc-linux.org
CC: akpm@linux-foundation.org, himangi774@gmail.com, julia.lawall@lip6.fr,
        mgorman@suse.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: FIX MES in init.c
References: <54207769.2020105@gmail.com>
In-Reply-To: <54207769.2020105@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:l+ZLCrs8DcuvxUhyf5+6J5tNUNbDb5UgINHDzfmKFhUpZF9v85x
 sTdtFlTTvL3uDCvvvRHBJgoRjk2GZyVfVl0PYiSp8VLHg/2RH8m7NvsFpAtWGM4mpQZI/ZO
 986IJzVqjEu+QQMfnDyHjud6kCxw+hECs3Wbev2un6PhSlPLAG0qKYpnwhvxlzvf2HWuW9B
 5sz37i6IFT0/NKCUf+wEQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On 09/22/2014 09:24 PM, nick wrote:
> Greetings James and Other Maintainers of the Parisc Architecture,
> I am wondering about two fix mes in init.c and how to fix them
> for being const declared into actual variables.
> ...
> 	/* FIXME: This is 'const' in order to trick the compiler
> 	   into not treating it as DP-relative data. */
> 	extern void * const linux_gateway_page;

The FIXME: is misleading. It should maybe better read "HINT:" or something like that.
Trivially it's basically just casting the symbol so that the compiler
will produce the correct code later on.
There is nothing you could try to "fix".

Helge
