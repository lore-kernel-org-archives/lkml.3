Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbaGPEdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:33:20 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:52365 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821AbaGPEdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:33:17 -0400
Message-ID: <53C6007A.9050707@synopsys.com>
Date: Wed, 16 Jul 2014 10:02:58 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: ARC backport for stable 3.{10,12,14,15}
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you please add the mainline commit a4b6cb735b25aa84a462a1985e3e43bebaf5beb4
"ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)" to stable kernels

This is causing buildroot gdb failures with pre 3.16 kernels.

Thx,
-Vineet
