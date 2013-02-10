Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3BJXux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:50:53 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54812 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab3BJXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:50:51 -0500
Date: Sun, 10 Feb 2013 15:50:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
Message-ID: <20130210235057.GA5485@kroah.com>
References: <cover.1360528614.git.dborkman@redhat.com>
 <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
 <1360538650.2028.2.camel@joe-AO722>
 <51182DAB.1030708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51182DAB.1030708@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 12:30:51AM +0100, Daniel Borkmann wrote:
> On 02/11/2013 12:24 AM, Joe Perches wrote:
> >On Sun, 2013-02-10 at 23:00 +0100, Daniel Borkmann wrote:
> >>add memcmp_nta ({n}o {t}iming {a}ttacks)
> >
> >Why should this be in the kernel?
> 
> As the commit message already says, so that current or future (e.g.) network
> protocol code or modules can make use of this when dealing with cryptographic
> hash comparisons.

Do we have any in-kernel users that need this?  If not, then don't add
it now, but rather, add it when we actually have a user.  We almost
never add kernel functions that no one calls, that would be just
wasteful.

sorry,

greg k-h
