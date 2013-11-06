Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3KFUdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:33:37 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58410 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab3KFUdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:33:35 -0500
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DEEC7E@US01WEMBX2.internal.synopsys.com>
References: <20130821184042.GC3577@xanatos>
	<CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
	<20130822004514.GB19747@xanatos>
	<CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
	<20130826191411.GG5112@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
	<20130828215142.GJ26483@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
	<CAODwPW_nPvS3Y9J2J9nU49uuDSB0kVirnKTF7HejfcYJEhgsUw@mail.gmail.com>
	<20130829171852.GB5538@xanatos>
	<CAODwPW9inceudHq9L7JB60q+g91UFxqtdpiS7T6PWvwS7RwA4g@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEEC7E@US01WEMBX2.internal.synopsys.com>
Date: Wed, 6 Nov 2013 12:33:33 -0800
X-Google-Sender-Auth: Y4WfYsBGOu9-rzalwFOgcYqnKuo
Message-ID: <CAODwPW-maNXVMQM4WzZC8ZSM-2Zh=7wezfTQ8p=78HTb05gB=A@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        Josh Triplett <josh.triplett@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*bump*

Hi Sarah, is there anything else that needs to be resolved to pick
this patch up? Looks like Matthias' recent LPM fixes are all in now so
there should be no way this could cause any trouble?
