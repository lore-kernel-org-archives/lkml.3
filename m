Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3H2QfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:35:11 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:44342 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613Ab3H2QfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:35:09 -0400
Date: Thu, 29 Aug 2013 16:35:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [guv v2 08/31] tracing: Replace __get_cpu_var uses
In-Reply-To: <20130828154804.20f4dde6@gandalf.local.home>
Message-ID: <00000140caeda84d-60e4dd5d-f119-4c9f-8d2e-d0d316e241b9-000000@email.amazonses.com>
References: <20130826204351.725357339@linux.com> <00000140bc5f00c2-8e9ffffa-de46-4329-aef3-317c258828bd-000000@email.amazonses.com> <20130828154804.20f4dde6@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.29-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013, Steven Rostedt wrote:

> You should limit the width of the change log to 76 characters.
>
> I fixed it for now.

Ok. I have to do that to all patches though. Next rollup.


