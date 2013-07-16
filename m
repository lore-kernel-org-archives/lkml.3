Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab3GPQeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:34:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36226 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932865Ab3GPQeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:34:17 -0400
Message-ID: <1373992455.1949.6.camel@joe-AO722>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peng Tao <bergwolf@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Date: Tue, 16 Jul 2013 09:34:15 -0700
In-Reply-To: <20130716063207.GB30320@kroah.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
	 <1373908589.2062.18.camel@joe-AO722> <20130715184030.GA17220@kroah.com>
	 <20130715121357.42ef2826750909c1fc57788a@linux-foundation.org>
	 <20130716000755.GC26261@kroah.com>
	 <CA+a=Yy6cC9rYcmAka2652UhJFse9eVfOtfg96SiObBiwsw+zQQ@mail.gmail.com>
	 <20130716063207.GB30320@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 23:32 -0700, Greg Kroah-Hartman wrote:
> I'll not apply those patches, don't worry, the shrinker stuff needs to
> stay in Andrew's tree until it hits Linus's.

To clarify, are you going to apply these 17 patches but not
those 5 patches in Andrew's tree?


