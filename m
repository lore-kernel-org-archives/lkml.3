Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaDDPQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbaDDPQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:16:30 -0400
Date: Fri, 4 Apr 2014 11:16:20 -0400
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
Message-ID: <20140404151620.GB2161@redhat.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
 <20140404141218.GA2161@redhat.com>
 <fb8d196a0c01479bae9c3669d8ea8be5@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb8d196a0c01479bae9c3669d8ea8be5@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 03:01:51PM +0000, KY Srinivasan wrote:

[..]
> The problem we were having is that the initial boot on the EFI firmware
> would succeed as the legacy PIC would be NULL legacy PIC, however
> in the kexeced kernel, the initial boot information is not available and so
> we would not set the legacy PIC to NULL legacy PIC.

I am curious to know what "initial boot information" is not available
in kexeced kernel and who is supposed to provide that.

Is it a bug or that's how it is supposed to work.

Thanks
Vivek
