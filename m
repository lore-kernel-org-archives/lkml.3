Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3CETTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:19:05 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34902 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759000Ab3CETTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:19:01 -0500
Date: Tue, 5 Mar 2013 20:18:40 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/gadget: initialize gadget functions helper befor
 functions & gadgets
Message-ID: <20130305191840.GB18329@kibibi>
References: <20130206020424.GB1175@localhost>
 <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
 <20130305095734.GA30166@localhost>
 <20130305103513.GA31454@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130305103513.GA31454@localhost>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fengguang Wu | 2013-03-05 18:35:13 [+0800]:

>Note that I still get this warning, however looks like an unrelated
>issue:
>
>[  602.536679] [ INFO: possible circular locking dependency detected ]
>[  602.536672] 
>[  602.536679] ======================================================
>[  602.536679] [ INFO: possible circular locking dependency detected ]
>[  602.536693] 3.8.0-bisect-next-20130301-dirty #212 Not tainted
>[  602.536694] -------------------------------------------------------
>[  602.536698] kworker/0:1/27 is trying to acquire lock:
>[  602.536750]  (&fb_info->lock){+.+.+.}, at: [<ffffffff814c0176>] lock_fb_info+0x26/0x60
>[  602.536751] 
>[  602.536751] but task is already holding lock:
>[  602.536773]  (console_lock){+.+.+.}, at: [<ffffffff815a6a13>] console_callback+0x13/0x150
>[  602.536774]                 
>[  602.536774] which lock already depends on the new lock.

This does not look good but it does not like USB. It looks more like the
tty/fb area.

>Thanks,
>Fengguang

Sebastian
