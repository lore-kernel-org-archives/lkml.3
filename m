Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3BMHcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:32:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42087 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3BMHcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:32:09 -0500
Message-ID: <1360740725.24917.25.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
From: Matt Fleming <matt.fleming@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Lingzhu Xiang <lxiang@redhat.com>,
        Dave Young <dyoung@redhat.com>
Date: Wed, 13 Feb 2013 07:32:05 +0000
In-Reply-To: <20130212155005.36f9a718.akpm@linux-foundation.org>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	 <1360162088.143076.913706486688.1.gpush@pecola>
	 <20130207151333.f01d415c.akpm@linux-foundation.org>
	 <5114CE00.6050307@ozlabs.org>
	 <1360318129.7515.278.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20130212155005.36f9a718.akpm@linux-foundation.org>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 15:50 -0800, Andrew Morton wrote:
> On Fri, 08 Feb 2013 10:08:49 +0000
> Matt Fleming <matt.fleming@intel.com> wrote:
> 
> > On Fri, 2013-02-08 at 18:05 +0800, Jeremy Kerr wrote:
> > > However, the tests expose a bug at the moment, so run_tests will fail. 
> > > Matt will have that fixed soon though :)
> > 
> > In which case, would it make more sense for me to take these tests
> > through the efi tree? I'm fine either way, I'm just looking for the
> > least surprising option.
> 
> I don't think it matters much at this stage.  selftests is new and is
> used by approximately zero people so if the tests fail, few will
> notice.  Let's just get it in there and get it settled down.

Fine by me. Thanks Andrew.

