Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098Ab3IDQgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:36:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964905Ab3IDQct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:32:49 -0400
Date: Wed, 4 Sep 2013 09:32:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH v3 0/7] Enable Drivers for Intel MIC X100 Coprocessors.
Message-ID: <20130904163248.GA19631@kroah.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
 <1378311520.72268.21.camel@blbiskey-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378311520.72268.21.camel@blbiskey-desk1.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 09:18:40AM -0700, Sudeep Dutt wrote:
> On Wed, 2013-08-21 at 10:51 -0700, Sudeep Dutt wrote:
> > ChangeLog:
> > =========
> > 
> > v2 => v3:
> > a) Patch 1 data structure cleanups, header file include cleanups,
> >    IDA interface reuse and switching to device_create_with_groups(..)
> >    as per feedback from Greg Kroah-Hartman.
> > b) Patch 7 signal documentation, sleep workaround removal and sysfs
> >    access API cleanups as per feedback from Michael S. Tsirkin.
> > 
> > v1 => v2: @ http://lwn.net/Articles/563131/
> > a) License wording cleanup, sysfs ABI documentation, patch 1 refactoring
> >    into 3 smaller patches and function renames, as per feedback from
> >    Greg Kroah-Hartman.
> > b) Use VRINGH infrastructure for accessing virtio rings from the host
> >    in patch 5, as per feedback from Michael S. Tsirkin.
> > 
> > v1: Initial post @ https://lwn.net/Articles/561314/
> > 
> 
> Hi Greg,
> 
> It has been a couple of weeks since we posted v3 @
> https://lwn.net/Articles/564795 which addresses all feedback received so
> far. Have you had a chance to review this version? Please let us know
> your thoughts.

I don't have this around anymore, I got 7 copies and thought your
patch-send script went crazy so I deleted them :(

Care to send them again?  But note, this is the merge window, so I'll
not be able to do anythign for at least 2 weeks with them.

thanks,

greg k-h
