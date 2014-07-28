Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaG1TbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:31:07 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49033 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750929AbaG1TbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:31:03 -0400
Message-ID: <53D6A4F0.6080909@hurleysoftware.com>
Date: Mon, 28 Jul 2014 15:30:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "xinhui.pan" <xinhuix.pan@intel.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm.c: fix a memory leak in gsmld_open
References: <53D6067C.4000702@intel.com>
In-Reply-To: <53D6067C.4000702@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 04:14 AM, xinhui.pan wrote:
> If gsmld_attach_gsm fails, the gsm is not used anymore.
> tty core will not call gsmld_close to do the cleanup work.
> tty core just restore to the tty old ldisc.
> That always causes memory leak.
> 
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> Reported-by: Peter Hurley <peter@hurleysoftware.com>

Looks good, thanks!

