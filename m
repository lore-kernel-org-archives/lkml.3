Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3FCBJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 21:09:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47431 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755254Ab3FCBJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 21:09:41 -0400
Message-ID: <1370221774.2096.7.camel@joe-AO722>
Subject: Re: [PATCH 3/4] sys/reboot: boolize C_A_D
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: liguang <lig.fnst@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Sun, 02 Jun 2013 18:09:34 -0700
In-Reply-To: <20130531160259.553761ddeb6095d22e8cea0d@linux-foundation.org>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1369900686-5936-3-git-send-email-lig.fnst@cn.fujitsu.com>
	 <20130531160259.553761ddeb6095d22e8cea0d@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 16:02 -0700, Andrew Morton wrote:
> there's no rule
> which states that sizeof(bool) must equal sizeof(int).

For gcc, sizeof(_Bool) isn't sizeof(int) so it would
work for one endian but not the other.

gcc has sizeof(_Bool) == sizeof(unsigned char)

