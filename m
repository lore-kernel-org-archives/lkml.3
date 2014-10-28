Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaJ1F4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:56:07 -0400
Received: from ozlabs.org ([103.22.144.67]:57162 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaJ1Fzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:55:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Paul McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 5/5] module: Remove stop_machine from module unloading
In-Reply-To: <20141023192711.10463.53532.stgit@localhost.localdomain>
References: <20141023192636.10463.45031.stgit@localhost.localdomain> <20141023192711.10463.53532.stgit@localhost.localdomain>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Oct 2014 11:50:25 +1030
Message-ID: <87oasx9ehy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> Remove stop_machine from module unloading by adding new reference
> counting algorithm.

Thankyou!

I have applied these to my tree, and they will enter Linus' next merge
window.

Thanks!
Rusty.
PS.  I created stop_machine for module unloading and CPU hotplug.  Maybe
     we'll get to remove it altogether soon :)
