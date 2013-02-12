Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab3BLXuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:50:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3BLXuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:50:06 -0500
Date: Tue, 12 Feb 2013 15:50:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Lingzhu Xiang <lxiang@redhat.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Message-Id: <20130212155005.36f9a718.akpm@linux-foundation.org>
In-Reply-To: <1360318129.7515.278.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	<1360162088.143076.913706486688.1.gpush@pecola>
	<20130207151333.f01d415c.akpm@linux-foundation.org>
	<5114CE00.6050307@ozlabs.org>
	<1360318129.7515.278.camel@mfleming-mobl1.ger.corp.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2013 10:08:49 +0000
Matt Fleming <matt.fleming@intel.com> wrote:

> On Fri, 2013-02-08 at 18:05 +0800, Jeremy Kerr wrote:
> > However, the tests expose a bug at the moment, so run_tests will fail. 
> > Matt will have that fixed soon though :)
> 
> In which case, would it make more sense for me to take these tests
> through the efi tree? I'm fine either way, I'm just looking for the
> least surprising option.

I don't think it matters much at this stage.  selftests is new and is
used by approximately zero people so if the tests fail, few will
notice.  Let's just get it in there and get it settled down.
