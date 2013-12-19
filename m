Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3LSP7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:59:41 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:47597 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3LSP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:59:39 -0500
Message-ID: <52B317EA.8020900@tilera.com>
Date: Thu, 19 Dec 2013 10:59:38 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
CC: <akpm@linuxfoundation.org>, <rostedt@goodmis.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/40] drivers/net/ethernet/tile: Replace __get_cpu_var
 uses for address calculation
References: <20131219155015.443763038@linux.com> <20131219155032.146331548@linux.com>
In-Reply-To: <20131219155032.146331548@linux.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 10:50 AM, Christoph Lameter wrote:
> Replace with this_cpu_ptr.
>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

