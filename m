Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3KEAJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:09:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3KEAJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:09:19 -0500
Date: Mon, 4 Nov 2013 16:09:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        handai.szj@taobao.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] percpu: add test module for various percpu
 operations
Message-Id: <20131104160918.0c571b410cf165e9c4b4a502@linux-foundation.org>
In-Reply-To: <1382895017-19067-2-git-send-email-gthelen@google.com>
References: <1382895017-19067-1-git-send-email-gthelen@google.com>
	<1382895017-19067-2-git-send-email-gthelen@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct 2013 10:30:15 -0700 Greg Thelen <gthelen@google.com> wrote:

> Tests various percpu operations.

Could you please take a look at the 32-bit build (this is i386):

lib/percpu_test.c: In function 'percpu_test_init':
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
