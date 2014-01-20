Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaATKXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:23:17 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:33423 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaATKXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:23:14 -0500
Date: Mon, 20 Jan 2014 12:23:10 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org
Subject: Re: [PATCH v3] perf: add support for the xtensa architecture
Message-ID: <20140120102310.GU12751@tarshish>
References: <aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il>
 <20140113104647.GA16230@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113104647.GA16230@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, Jan 13, 2014 at 11:46:47AM +0100, Ingo Molnar wrote:
> * Baruch Siach <baruch@tkos.co.il> wrote:
> > Tested using kernel tracepoints on a QEMU simulated environment. Kernel 
> > support
> > for perf depends on the patch "xtensa: enable HAVE_PERF_EVENTS", which is
> > scheduled for v3.14. Hardware performance counters are not supported under
> > xtensa yet.
> > 
> > Acked-by: Max Filippov <jcmvbkbc@gmail.com>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks. So is it going into v3.14 by any chance?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
