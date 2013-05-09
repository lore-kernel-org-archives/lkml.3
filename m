Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3EIUbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:31:09 -0400
Received: from mout.gmx.net ([212.227.17.21]:56300 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab3EIUbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:31:07 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/wonAacdTw0qT4tbjXyplHWh1r6HRL1ClcbQ0Vux
	omk8OMj+H+RRiG
Message-ID: <518C0788.8060200@gmx.de>
Date: Thu, 09 May 2013 22:31:04 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] parisc updates for v3.10
References: <20130507221102.GA5338@p100.box> <20130508113704.5ac23906e0e513b4a76d5b55@canb.auug.org.au>
In-Reply-To: <20130508113704.5ac23906e0e513b4a76d5b55@canb.auug.org.au>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 05/08/2013 03:37 AM, Stephen Rothwell wrote:
> On Wed, 8 May 2013 00:11:02 +0200 Helge Deller <deller@gmx.de> wrote:
>>
>> please pull the parisc architecture updates for v3.10 from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-for-3.10
> 
> Does this mean that the parisc tree I have in linux-next
> (git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#for-next)
> is defunct?

Not sure. It will be either James or me who will send pull requests...
Of course we will agree who of us will do that and from which tree.

So, would it hurt if you add a second parisc tree for linux-next?
I've just created a "for-next" branch in my git repository: 
git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git#for-next

Helge
