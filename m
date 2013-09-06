Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750788Ab3IFEyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:54:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3IFEyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:54:39 -0400
Date: Thu, 5 Sep 2013 21:57:22 -0700
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
Subject: Re: [PATCH RESEND v3 1/7] Intel MIC Host Driver for X100 family.
Message-ID: <20130906045722.GC28806@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
 <8b972a444f4529ecffc718db4112aa8959bf72ad.1378423596.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b972a444f4529ecffc718db4112aa8959bf72ad.1378423596.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 04:41:31PM -0700, Sudeep Dutt wrote:
>  drivers/misc/mic/common/mic_device.h          |  37 +++
>  drivers/misc/mic/host/mic_device.h            | 109 +++++++++

Two different files, with the same name?  You are asking for trouble in
the future, getting them confused :)

Please try to pick a unique name, especially when you later do things
like:

> +#include "../common/mic_device.h"
> +#include "mic_device.h"

Which just looks odd.

Again, not a big deal, follow-on patch can fix this.

thanks,

greg k-h
