Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaCCOXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:23:22 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38278 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaCCOXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:23:20 -0500
Message-ID: <1393856593.32410.26.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 2/8] integrity: fix checkpatch errors
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        casey.schaufler@intel.com
Date: Mon, 03 Mar 2014 09:23:13 -0500
In-Reply-To: <CACE9dm_KXUqBV00QeCfYyb22HUFxcjOKLhv29ARMze9QCDPdVQ@mail.gmail.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <ffe24f199d8af75172b4cd23507a529f4a2d5c5a.1393599538.git.d.kasatkin@samsung.com>
	 <1393854085.32410.14.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm_KXUqBV00QeCfYyb22HUFxcjOKLhv29ARMze9QCDPdVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030314-3532-0000-0000-0000062B0206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 16:01 +0200, Dmitry Kasatkin wrote: 
> On Mon, Mar 3, 2014 at 3:41 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote:
> >> Unfixed checkpatch errors make it difficult to see new errors..
> >> This patch fix them.
> >
> > A number of these errors are a result of inconsistencies between Lindent
> > and checkpatch.  This patch uses the checkpatch preferences.
> >
> >> Some lines with over 80 chars remained unchanged to improve
> >> code readability.
> >>
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >
> > This patch doesn't apply cleanly to either linux-integrity/next-fixes or
> > to linux-security/next.
> >
> > thanks,
> >
> 
> Hi,
> 
> Did you apply  Joe Perches's patch what you signed-off first?

Thanks for the reminder. I hadn't applied Joe's patch, but that didn't
resolve it.

Mimi

