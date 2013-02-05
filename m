Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3BEUYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:24:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44175 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab3BEUYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:24:11 -0500
Message-ID: <1360094930.3859.90.camel@falcor1>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Peter Jones <pjones@redhat.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Feb 2013 15:08:50 -0500
In-Reply-To: <20130205180300.GE2335@fenchurch.internal.datastacks.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	 <20130205180300.GE2335@fenchurch.internal.datastacks.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020520-5806-0000-0000-00001F39A005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 13:03 -0500, Peter Jones wrote:

> It's not clear to me why we need this encapsulation - wouldn't it be
> better to add another [pointer,size] pair to the bootloader protocol
> with a structure like:

https://lkml.org/lkml/2013/1/30/68 was in response to the assumption
that the initramfs is measured/appraised.  These patches attempt to
address those concerns.

Mimi

