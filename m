Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaLQPbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:31:18 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:45055 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbaLQPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:31:16 -0500
Date: Wed, 17 Dec 2014 09:31:11 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Paolo Bonzini <pbonzini@redhat.com>
cc: Alexander Graf <agraf@suse.de>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 26/35] [PATCH 26/36] powerpc: Replace __get_cpu_var
 uses
In-Reply-To: <54915050.8070307@redhat.com>
Message-ID: <alpine.DEB.2.11.1412170929180.2047@gentwo.org>
References: <20140817173023.439660246@linux.com> <20140817173036.985604442@linux.com> <20140826181444.GJ31659@mtj.dyndns.org> <5490AD09.3000807@suse.de> <54915050.8070307@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Paolo Bonzini wrote:

> I can also ask Linus to squash it in the merge.

Merge the fix please. Further patches were merged that remove
the __get_cpu_var macro. Reversion of the patch will cause more breakage.

