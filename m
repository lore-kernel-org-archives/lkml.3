Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3BDQof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:44:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:24883 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab3BDQod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:44:33 -0500
Message-ID: <1359996265.7515.180.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [ 105/128] efi: Make efi_enabled a function to query EFI
 facilities
From: Matt Fleming <matt.fleming@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 04 Feb 2013 16:44:25 +0000
In-Reply-To: <1359904557.1822.2.camel@deadeye.wl.decadent.org.uk>
References: <20130203144653.313760856@decadent.org.uk>
	 <1359904557.1822.2.camel@deadeye.wl.decadent.org.uk>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-03 at 16:15 +0100, Ben Hutchings wrote:
> As you can see this needed quite a lot of work to backport, and I
> haven't been able to test it yet.  So I would particularly appreciate
> careful review of this.

Everything looks fine to me but I haven't actually booted with these
changes.



