Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab3GLLfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:35:15 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54474 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab3GLLfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:35:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Bin Gao <bin.gao@linux.intel.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
Date: Fri, 12 Jul 2013 13:35:51 +0200
Message-ID: <4066449.W80oPjbVFF@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CAHp75Ve8oLeT=-_t96i_ctcmnM4kEPHD0cBjBroJTnYxwczBmw@mail.gmail.com>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com> <20130712110047.GA3135@katana> <CAHp75Ve8oLeT=-_t96i_ctcmnM4kEPHD0cBjBroJTnYxwczBmw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Friday 12 July 2013 14:29:16 Andy Shevchenko wrote:
> On Fri, Jul 12, 2013 at 2:00 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> >> Briefly looking into ACPI tables we have and mechanisms that we can
> >> use in ACPI case, I doubt we may apply all the ideas, probably some of
> >> them, though I didn't get yet where to read about in details. What I
> >> could say now is that the patch provided by Bin Gao is definitely no
> >> go.
> > 
> > Laurent explained to me what V4L did and now does. It used to be the way
> > tha V4L drivers did register I2C slaves according to platform_data. Now,
> > with DT the slaves get instanciated earlier, so they now use notifiers
> > to know when the slaves are in place. Something like this should
> > probably be done here, too, instead of unregistering and re-registering.
> 
> Yes, seems right way to go.
> I think ACPI case can use V4L2 async API somehow, though it has its
> own event model.
> I'll talk to Sakari Ailus to sync.

Do you have any pointer to the relevant parts of the ACPI specification ?

-- 
Regards,

Laurent Pinchart

