Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161797Ab3DENu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161203Ab3DENu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:50:27 -0400
Date: Fri, 5 Apr 2013 09:50:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130405135000.GB6299@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
 <20130205181926.GA13942@srcf.ucam.org>
 <20130205183436.GC12853@redhat.com>
 <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 11:55:09PM +0200, Kasatkin, Dmitry wrote:

[..]
> > Also I am assuming that from signed initramfs, keys will be loaded in
> > appropriate keyrings and then keyring will be locked so that any
> > tools from unsigned initramfs can not load additional keys.
> >
> 
> Exactly like that.

Dmitry,

[ Following up on this thread after a very long time ]

I was thinking about this point that keys can be loaded from signed
initramfs. But how is it better than embedding the keys in kernel the
way we do for module signing and lock down ima keyring before control
is passed to initramfs.

Reason being, that anyway a user can not put its own keys in signed
initramfs. Signed initramfs will be shipped by distribution. So then
it does not matter whether distribution's keys are embedded in the
kernel or are loaded from signed initramfs.

Thanks
Vivek
