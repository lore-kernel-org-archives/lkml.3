Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaFDRHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:07:23 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:42631 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaFDRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:07:21 -0400
Date: Wed, 4 Jun 2014 13:07:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [GIT PULL] last minute percpu fix for v3.15-rc8
Message-ID: <20140604170709.GL5004@htj.dyndns.org>
References: <20140604163700.GH5004@htj.dyndns.org>
 <20140604165953.GJ5004@htj.dyndns.org>
 <CA+55aFxcpWjpn0qezNVFiE7_pLWY9+i-6Q0+Guqya9d64r8Tnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxcpWjpn0qezNVFiE7_pLWY9+i-6Q0+Guqya9d64r8Tnw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:06:07AM -0700, Linus Torvalds wrote:
> On Wed, Jun 4, 2014 at 9:59 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, again.
> >
> > My script applied the patch with the wrong author.  It should have
> > been Heiko instead of Sebastian.  I fixed up percpu/for-3.15-fixes
> > branch accordingly.
> 
> I'm just too fast for you. The previous one is already pulled and
> pushed out, and Ott got authorship.

Urgh... Sorry, Heiko.  I owe you a beer.

-- 
tejun
