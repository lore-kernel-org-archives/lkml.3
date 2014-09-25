Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaIYPim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:38:42 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65149 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIYPik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:38:40 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 25 Sep 2014 17:36:05 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mfd: viperboard: remove unused platform_device
Message-ID: <20140925153605.GI32124@localhost>
References: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
 <1411656197-26517-4-git-send-email-octavian.purdila@intel.com>
 <20140925150757.GH32124@localhost>
 <CAE1zotLcBNe7M_303qcHa8DQg9B17m516hUN5-CoZ2qweawXuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotLcBNe7M_303qcHa8DQg9B17m516hUN5-CoZ2qweawXuQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:29:48PM +0300, Octavian Purdila wrote:
> On Thu, Sep 25, 2014 at 6:07 PM, Johan Hovold <johan@kernel.org> wrote:

> > Still feels like the kind of clean up that should have a Tested-by.
> 
> Unfortunately I do not have access to hardware to test.

On second thought, compile-testing should be enough. But please add a
proper commit message.

Johan
