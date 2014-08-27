Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193AbaH0P4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:56:33 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:54260
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934964AbaH0P4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:56:31 -0400
Date: Wed, 27 Aug 2014 10:56:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH percpu/for-3.18-consistent-ops] Revert "powerpc: Replace
 __get_cpu_var uses"
In-Reply-To: <20140827152609.GA379@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1408271055030.17080@gentwo.org>
References: <20140827142243.6277eaff@canb.auug.org.au> <20140827152609.GA379@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Tejun Heo wrote:

> Chrisoph, let's route the updated patch through powerpc tree.

Ok. Once I figure out what went wrong. This went through Feng's build
system and I though he did a powerpc build. So it must be a difference
configuration on powerpc.

