Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbbA2BUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:20:00 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50129 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbbA2BTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:19:41 -0500
Date: Wed, 28 Jan 2015 22:31:23 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, aik@ozlabs.ru,
        shreyas@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au, Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V3] tick/broadcast: Make movement of broadcast hrtimer
 robust against hotplug
Message-ID: <20150128213123.GA27411@localhost.localdomain>
References: <20150120103559.8430.50933.stgit@preeti.in.ibm.com>
 <alpine.DEB.2.11.1501211243270.5526@nanos>
 <54C09391.9080202@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1501221209260.5526@nanos>
 <54C7068B.3050108@linux.vnet.ibm.com>
 <54C8B3D2.3070608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C8B3D2.3070608@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 03:32:58PM +0530, Preeti U Murthy wrote:
> Thomas ping. Would you be posting this patch?

FYI, Thomas is temporarily out of action, in bed with the flu.

Thanks,
Richard
