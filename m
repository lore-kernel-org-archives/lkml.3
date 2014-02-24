Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaBXNgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:36:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:48653 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752301AbaBXNgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:36:40 -0500
Date: Mon, 24 Feb 2014 08:36:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: combine per-cpu trace files
Message-ID: <20140224083631.192868c0@gandalf.local.home>
In-Reply-To: <530B3616.70409@broadcom.com>
References: <530B3616.70409@broadcom.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 13:07:50 +0100
Arend van Spriel <arend@broadcom.com> wrote:

> Hi Steven,
> 
> Regarding trace-cmd I have a question about the trace files. While
> debugging an driver issue I had trace-cmd recording driver events on the
> target system until it crashed and I had to power down the machine. Now
> I have three trace-cmd files: trace.dat, trace.cpu1 and trace.cpu2.
> trace-cmd combines the per-cpu files into final trace.dat, but would it
> be possible to do that as a separate post process after a crash/abort.

Yep, if you installed the trace-cmd man pages (make install_doc) then
do a "man trace-cmd-restore"

-- Steve

