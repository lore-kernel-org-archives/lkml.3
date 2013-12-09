Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3LIUWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:22:48 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:55069 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3LIUWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:22:47 -0500
Message-ID: <52A62696.10406@tilera.com>
Date: Mon, 9 Dec 2013 15:22:46 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
CC: <akpm@linuxfoundation.org>, <rostedt@goodmis.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 25/41] drivers/net/ethernet/tile: Replace __get_cpu_var
 uses for address calculation
References: <20131203233232.928771708@linux.com> <20131203233258.055104802@linux.com>
In-Reply-To: <20131203233258.055104802@linux.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/2013 6:32 PM, Christoph Lameter wrote:
> Replace with this_cpu_ptr.
>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

