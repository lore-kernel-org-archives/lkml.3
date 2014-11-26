Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaKZObX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:31:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13212 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752595AbaKZObU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:31:20 -0500
Date: Wed, 26 Nov 2014 09:31:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace
 IPMODIFY flag test
Message-ID: <20141126093103.4531e485@gandalf.local.home>
In-Reply-To: <54733C80.6060509@hitachi.com>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
	<20141121102537.11844.9781.stgit@localhost.localdomain>
	<20141121160329.575fd043@gandalf.local.home>
	<54729CDE.5030700@hitachi.com>
	<20141123232932.1ed70d18@gandalf.local.home>
	<54733C80.6060509@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 23:11:12 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> I hope to have CONFIG_KSELFTEST_BINARIES for Kconfig, or make prep_kselftest
> target to build these binaries with kernel...

For binaries (not modules), would that the server and client would need
the same environment? Make sure they both have the same shared
libraries. Or will the binaries all be built statically linked?

-- Steve
