Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaIFX2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 19:28:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44601 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaIFX22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 19:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo57EyJj1uc+oqvmy+_10AwwhrOQEO=EQbB2zs-7gd9tFA@mail.gmail.com>
References: <53FFA54D.9000907@gmail.com>
	<CAErSpo5_WMUmnTHpPZt+j04VZoiW1pthQoGV90A5BDQpQgjwOQ@mail.gmail.com>
	<CA+55aFy63sEs2zvr0LzKSjxSRuH5paLG378qQ6_QyLmmJw=D3w@mail.gmail.com>
	<CAErSpo57EyJj1uc+oqvmy+_10AwwhrOQEO=EQbB2zs-7gd9tFA@mail.gmail.com>
Date: Sat, 6 Sep 2014 16:28:27 -0700
X-Google-Sender-Auth: YscHpmxovTDEwsYBh0dGyXizpoE
Message-ID: <CA+55aFxyjLKCr6xpYWtXW34_Z3v1_V2WB1vD583mAcPtGijn9A@mail.gmail.com>
Subject: Re: [PATCH] pci/probe: Enable CRS for Intel Haswell root ports
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Richard Yang <weiyang@linux.vnet.ibm.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Josh Logan <joshtlogan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 2:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> But as you point out, we don't see the "not responding" message.  We
> only print that if we read 0xffff0001 (device/vendor ID).  But lspci
> claims the vendor:device ID is 0001:8168.  So my new theory is:

[snip]

Sounds like a very reasonable theory and quite possible. And if Josh
actually still has the hardware, it would be lovely to hear the
results. Josh?

                 Linus
