Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaLCXzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:55:23 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:26116 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaLCXzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:55:21 -0500
Message-ID: <547FA2E5.1040105@imgtec.com>
Date: Wed, 3 Dec 2014 15:55:17 -0800
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>
CC: <Zubair.Kakakhel@imgtec.com>, <geert+renesas@glider.be>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <macro@linux-mips.org>, <chenhc@lemote.com>, <cl@linux.com>,
        <mingo@kernel.org>, <richard@nod.at>, <zajec5@gmail.com>,
        <james.hogan@imgtec.com>, <keescook@chromium.org>, <tj@kernel.org>,
        <alex@alex-smith.me.uk>, <pbonzini@redhat.com>, <blogic@openwrt.org>,
        <paul.burton@imgtec.com>, <qais.yousef@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <lars.persson@axis.com>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/3] MIPS: Add full ISA emulator.
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com> <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 03:44 PM, David Daney wrote:

(...)

Big work but it doesn't support customized instructions, multiple ASEs, 
MIPS R6 etc.

Well, it is still not a replacement of XOL emulation.
Even close.


