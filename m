Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaAQQap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:30:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56996 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaAQQal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:30:41 -0500
Message-ID: <52D95A7C.4060508@zytor.com>
Date: Fri, 17 Jan 2014 08:29:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
CC: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH 27/41] x86: Replace __get_cpu_var uses
References: <20140117151812.770437629@linux.com> <20140117151837.200391582@linux.com>
In-Reply-To: <20140117151837.200391582@linux.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 07:18 AM, Christoph Lameter wrote:
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

