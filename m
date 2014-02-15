Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaBOH4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 02:56:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaBOH4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 02:56:05 -0500
Message-ID: <1392450890.5517.49.camel@marge.simpson.net>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Date: Sat, 15 Feb 2014 08:54:50 +0100
In-Reply-To: <20140214232636.0a683ca0@gandalf.local.home>
References: <20140214201841.826179349@linux.com>
	 <20140214201908.082769265@linux.com> <1392436208.10050.22.camel@pasglop>
	 <20140214232636.0a683ca0@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:X9sgo/IdTjRNv/6zwNQnR/rpEyyQavUGBMhPRoDparK
 lo3VzseAkB1aN4mpV+rSEadiQ2nQyyQzHA8/ryh4yZGzqHtWc7
 cdFdWcpYgKRxOuXTGrPY6nGdsuHxBvhE7UyouKrshzQU7pn6/E
 sl1N8h+pFMlvCAZdK6PUeH1UwdY3Jh8h5XqeZTmoJQyxQsogkd
 oFbbrFCcMpkB9Wv1po0vOAnrBis0n2GD/Ch7lePwVLpgsprdwe
 sHRcFOWfksfNnVD/3IVJqrM9jHDTdYw2o4PSsk0P0p5hM189e5
 xaKOWcid3lito36e2ANi7cvxsAJpKr4JOkaweRc0kcbHMnA1s5
 V2JG/33drgxZ4jdlPYbAcmnqGaofONJ/OSxlRVsdwQY/sbyd4G
 /v6w9KMeN5F+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 23:26 -0500, Steven Rostedt wrote: 
> On Sat, 15 Feb 2014 14:50:08 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > For some reason Im still getting these as attachments instead of inline
> > in the email, which makes reviewing a major PITA. Christoph, I'm not
> > sure what you are doing wrong here but you should consider fixing it :-)
> 
> Get a better email client ;-)

Yeah, evolution shows them inline just fine (thought you made it do bad
things too, it couldn't save signed patches or such).

-Mike

