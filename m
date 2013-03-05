Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3CEVSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:18:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:39311 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab3CEVSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:18:33 -0500
Date: Tue, 5 Mar 2013 22:18:27 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v4 00/32] ldisc patchset
Message-ID: <20130305211827.GB5771@linutronix.de>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
 <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley | 2013-02-20 15:02:47 [-0500]:

>Sebastian, please re-test your g_nokia+dummy_hcd testcase with
>this series.

I tested this on top ov v3.9-rc1. Without this series I see often a
warning in drivers/tty/tty_buffer.c:428 / flush_to_ldisc(). With this
things seem to work fine.

Sebastian
