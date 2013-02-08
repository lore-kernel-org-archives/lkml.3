Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947300Ab3BHWqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:46:12 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42406 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366Ab3BHWqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:46:10 -0500
Message-ID: <1360363566.7515.310.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v5 -next 0/2] make efivars/efi_pstore interrupt-safe
From: Matt Fleming <matt.fleming@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Date: Fri, 08 Feb 2013 22:46:06 +0000
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A884D6@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5419C@USINDEM103.corp.hds.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A884D6@USINDEM103.corp.hds.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 22:31 +0000, Seiji Aguchi wrote:
> Matt,
> 
> Can you please take a look at this patchset which removes
> create_sysfs_entries() from efi_pstore_write()?
> 
> It has been updated in accordance with Mike's comment and fixes an
> actual bug.
> http://comments.gmane.org/gmane.linux.kernel.efi/406

OK, I'll find some time to review these.

