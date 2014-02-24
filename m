Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaBXMHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:07:54 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:50263 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaBXMHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:07:53 -0500
X-IronPort-AV: E=Sophos;i="4.97,534,1389772800"; 
   d="scan'208";a="16310573"
Message-ID: <530B3616.70409@broadcom.com>
Date: Mon, 24 Feb 2014 13:07:50 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>
Subject: combine per-cpu trace files
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Regarding trace-cmd I have a question about the trace files. While
debugging an driver issue I had trace-cmd recording driver events on the
target system until it crashed and I had to power down the machine. Now
I have three trace-cmd files: trace.dat, trace.cpu1 and trace.cpu2.
trace-cmd combines the per-cpu files into final trace.dat, but would it
be possible to do that as a separate post process after a crash/abort.

Regards,
Arend
