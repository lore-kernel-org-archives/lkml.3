Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaDOIR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:17:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47819 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbaDOIRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:17:22 -0400
X-Sasl-enc: svXHbEcl6IbKEuHkM679bytTrlj92wbNajXdmjJPNpYm 1397549839
Message-ID: <534CEB0D.6020709@iki.fi>
Date: Tue, 15 Apr 2014 11:17:17 +0300
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, vegard.nossum@oracle.com,
        penberg@kernel.org
CC: jamie.iles@oracle.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 4/4] kmemcheck: Switch to using kernel disassembler
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-4-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1397497450-6440-4-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 08:44 PM, Sasha Levin wrote:
> kmemcheck used to do it's own basic instruction decoding, which is
> just a duplication of the work done in arch/x86/lib/insn.c.
>
> Instead, switch it to using the already existing dissasembler, and
> switch the magic opcode numbers into something meaningful.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Vegard probably should take a closer look at this but:

Acked-by: Pekka Enberg <penberg@kernel.org>
