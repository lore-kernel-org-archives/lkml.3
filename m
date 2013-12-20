Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab3LTR7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:59:38 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:38824 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab3LTR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:59:23 -0500
Date: Fri, 20 Dec 2013 11:59:18 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Max Filippov <jcmvbkbc@gmail.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH 37/40] alpha: Replace __get_cpu_var
In-Reply-To: <CAMo8BfJY0rGLyeOwjmrzRw4h2AedF33D3iPXDe+umHDXt5=nQw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1312201159020.13885@nuc>
References: <20131219155015.443763038@linux.com> <20131219155034.661090897@linux.com> <CAMo8BfJY0rGLyeOwjmrzRw4h2AedF33D3iPXDe+umHDXt5=nQw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Max Filippov wrote:

> Doesn't it actually convert to __this_cpu_write(y, x); as there were
> no atomicity in the original assignment?

Correct that is what is done. Descriptions have been updated.

