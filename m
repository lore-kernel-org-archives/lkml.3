Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaBNLEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:04:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:40841 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaBNLEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:04:35 -0500
Date: Fri, 14 Feb 2014 12:04:32 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT] Cleanup of unnecessary do while 0 in api mappings
Message-ID: <20140214110432.GB28438@linutronix.de>
References: <20140208113920.GA3861@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140208113920.GA3861@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-08 12:39:20 [+0100]:

>
>Cleanup of unnecessary do while 0 in api mappings
>
>With the migration pushdonw a few of the do{ }while(0)
>loops became obsolete but got left over - this patch 
>only removes this fallout.
>
>Patch applies on top of 3.12.9-rt13
>
>Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Applied.

Sebastian
