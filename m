Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaDDUca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:32:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaDDUc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:32:28 -0400
Date: Fri, 4 Apr 2014 16:32:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL legacy
 PIC
Message-ID: <20140404203218.GA26102@redhat.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
 <20140404141218.GA2161@redhat.com>
 <fb8d196a0c01479bae9c3669d8ea8be5@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140404151620.GB2161@redhat.com>
 <9a22bbc2850941819cd2c71a26c584d5@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a22bbc2850941819cd2c71a26c584d5@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 08:09:47PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Vivek Goyal [mailto:vgoyal@redhat.com]
> > Sent: Friday, April 4, 2014 8:16 AM
> > To: KY Srinivasan
> > Cc: x86@kernel.org; linux-kernel@vger.kernel.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com; hpa@zytor.com;
> > stable@vger.kernel.org; Dave Young
> > Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
> > legacy PIC
> > 
> > On Fri, Apr 04, 2014 at 03:01:51PM +0000, KY Srinivasan wrote:
> > 
> > [..]
> > > The problem we were having is that the initial boot on the EFI
> > > firmware would succeed as the legacy PIC would be NULL legacy PIC,
> > > however in the kexeced kernel, the initial boot information is not
> > > available and so we would not set the legacy PIC to NULL legacy PIC.
> > 
> > I am curious to know what "initial boot information" is not available in
> > kexeced kernel and who is supposed to provide that.
> > 
> > Is it a bug or that's how it is supposed to work.
> 
> As the name indicates, the dump kernel is not "booted" but it is kexeced.
> In the address space of this second kernel, the initial boot state is not visible.

What do you mean by "initial boot state"? Most of the state we pass to
second kernel in bootparams and on command line and rest second kernel
can query from firmware as needed.

Thanks
Vivek
