Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbbAHVvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:51:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:45869 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbbAHVvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:51:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,725,1413270000"; 
   d="scan'208";a="666704886"
Date: Thu, 8 Jan 2015 13:51:37 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: kbuild-all@01.org, Anders Berg <anders.berg@avagotech.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [wsa:i2c/quirks 7/11] drivers/i2c/busses/i2c-axxia.c:452:27:
 sparse: symbol 'axxia_i2c_quirks' was not declared. Should it be static?
Message-ID: <20150108215137.GA11727@wfg-t540p.sh.intel.com>
References: <201501090118.jHaamxHl%fengguang.wu@intel.com>
 <20150108182847.GA29629@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108182847.GA29629@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Jan 08, 2015 at 07:28:48PM +0100, Wolfram Sang wrote:
> On Fri, Jan 09, 2015 at 01:57:37AM +0800, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux i2c/quirks
> > head:   b1d39af8ae21f4930854b0656aa83a83fd38049e
> > commit: 70181ecd2990326a91edb3dac1db4cce21e561f7 [7/11] i2c: axxia: make use of the new infrastructure for quirks
> > reproduce:
> >   # apt-get install sparse
> >   git checkout 70181ecd2990326a91edb3dac1db4cce21e561f7
> >   make ARCH=x86_64 allmodconfig
> >   make C=1 CF=-D__CHECK_ENDIAN__
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> > >> drivers/i2c/busses/i2c-axxia.c:452:27: sparse: symbol 'axxia_i2c_quirks' was not declared. Should it be static?
> > 
> > Please review and possibly fold the followup patch.
> 
> Yes, it should be static.
> 
> However, this is a development branch and in this case it would be
> enough if the test results would be directed to me only.

It's normally private emails, except for the ones that carry patches
with them. In which case public mailing lists will also be CCed.

> Is there a way to achieve this? I know that adding "experimental" to the
> branch name will skip the testing. Is there another pattern to prevent
> sending mails to everyone?

I wonder if the occasional public emails are acceptable to you. If
not, it'd be trivial for me to add a list of "personal git trees"
where all emails including the auto generated patches will be kept
private (if commit author == committer).

Thanks,
Fengguang
