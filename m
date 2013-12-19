Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3LSVbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:31:38 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:34993 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab3LSVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:31:37 -0500
Date: Thu, 19 Dec 2013 15:31:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Daney <ddaney.cavm@gmail.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 29/40] mips: Replace __get_cpu_var uses
In-Reply-To: <52B330F3.4090603@gmail.com>
Message-ID: <alpine.DEB.2.10.1312191529390.18447@nuc>
References: <20131219155015.443763038@linux.com> <20131219155033.834416420@linux.com> <52B330F3.4090603@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, David Daney wrote:

> I applied patches 01-16,18-23,25-29  (17 and 24 went missing)

Hmmm... I am still not seeing 01 and 15 on lkml but I have 17 and 24.


