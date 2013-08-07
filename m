Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3HGHci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:32:38 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40297 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab3HGHcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:32:36 -0400
Date: Wed, 07 Aug 2013 02:32:29 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for
 "uapi/Kbuild" and "uapi/linux/Kbuild"
To: Joe Perches <joe@perches.com>
Cc: Chen Gang <gang.chen@asianux.com>, "'Jiri Kosina'" <trivial@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <52005571.4080704@asianux.com>
	<1375810303.2424.28.camel@joe-AO722>
In-Reply-To: <1375810303.2424.28.camel@joe-AO722> (from joe@perches.com on
	Tue Aug  6 12:31:43 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1375860749.8422.25@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 12:31:43 PM, Joe Perches wrote:
> On Tue, 2013-08-06 at 09:46 +0800, Chen Gang wrote:
> > "include/uapi/" is the whole Linux kernel API, it is important  
> enough
> > to get more global explanations by comments.
> 
> It'd probably be useful to have more descriptions
> of uapi in the Documentation directory too.

I'd rather have comments in the headers that get exported to userspace  
and then have other forms of documentation generated from that by some  
process similar to "make htmldocs". Otherwise you've got two places to  
keep in sync.

(Really the guy you've got to keep in the loop about this is Michael  
Kerrisk. The section 2 man pages are the current best reference on UAPI  
stuff...)

Rob