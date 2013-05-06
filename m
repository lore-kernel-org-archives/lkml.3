Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab3EFWgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:36:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:12650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab3EFWgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:36:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="332790832"
Date: Mon, 6 May 2013 15:42:35 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci/mrst: force all pci config toward 0:0:0, 0:2:0 and 0:3:0
 to type 1
Message-ID: <20130506224235.GB50060@bingao-desk1.fm.intel.com>
References: <20130430072147.GA37866@bingao-desk1.fm.intel.com>
 <CAErSpo6g0xXo+HH+ZOYZav_Y6ZUH2D2FAqN+uDqrJqxQCRObog@mail.gmail.com>
 <20130502065358.GA41008@bingao-desk1.fm.intel.com>
 <CAErSpo66x7eHOy3nqH5kgKjOd-176zgNs3EGpJxYrk1dcKPQPg@mail.gmail.com>
 <CAErSpo4GPMD1kSW7qxBvQmN30NOyx_KruzsFY6SVXkFRMBcDmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4GPMD1kSW7qxBvQmN30NOyx_KruzsFY6SVXkFRMBcDmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 11:56:38AM -0700, Bjorn Helgaas wrote:
> I hate it when I go to the trouble of reviewing something and asking
> relevant questions, and then people ignore the questions :(
Sorry for that.
 
> I'd still like to know whether multi-function devices are possible at
> bus 0, device 0, 2, or 3.
0000:00:00.0 is host bridge.
0000:00:02.0 and 0000:00:03.0 are single-function devices.

> Are these devices built-in, so you know exactly what they are and they
> can never be anything else? 
Yes, they are built-in devices and I know exactly what they are.

> Or is there a slot or other way to connect a user-chosen device?
No, not that way.

> If you included "lspci -vv" output, that would make this much easier
> to talk about.
I'm sorry the busybox shrinks lspci options so it doesn't have
meaningful ouput excpet for DID:VID and class code.
