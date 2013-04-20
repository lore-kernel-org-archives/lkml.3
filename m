Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab3DTQTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:19:30 -0400
Received: from relay1.blacknight.com ([78.153.203.204]:57670 "EHLO
	relay1.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab3DTQT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:19:29 -0400
Message-ID: <5172C0A2.4080103@nexus-software.ie>
Date: Sat, 20 Apr 2013 17:21:54 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@alien8.de, bryan.odonoghue.lkml@nexus-software.ie,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
CC: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, microcode: Verify the family before dispatching
 microcode patching
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <tip-74c3e3fcf350b2e7e3eaf9550528ee3f74e44b37@git.kernel.org>
In-Reply-To: <tip-74c3e3fcf350b2e7e3eaf9550528ee3f74e44b37@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works for me
