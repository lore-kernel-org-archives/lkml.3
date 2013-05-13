Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3EMKCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:02:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:53377 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3EMKCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:02:05 -0400
Message-ID: <1368439305.19924.38.camel@pasglop>
Subject: Re: [RFC PATCH v3 2/5] powerpc: Exception hooks for context
 tracking subsystem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, paulus@samba.org,
        michael@ellerman.id.au
Date: Mon, 13 May 2013 20:01:45 +1000
In-Reply-To: <1368438380.2618.52.camel@ThinkPad-T5421>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368422493-9831-3-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368424667.19924.26.camel@pasglop>
	 <1368434680.2618.33.camel@ThinkPad-T5421>
	 <1368435991.19924.35.camel@pasglop>
	 <1368438380.2618.52.camel@ThinkPad-T5421>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 17:46 +0800, Li Zhong wrote:
> > hash_page() won't start a new RCU, at least not in its current incarnation,
> > the only thing I can see it ever doing would be to take some RCU read locks one
> > day (it doesn't today).
> 
> Seems I added the hooks because of the trace point of hcall
> entry/exit ...

Oh I see, and trace points use RCU ... ok, leave it there then.

Cheers,
Ben.


