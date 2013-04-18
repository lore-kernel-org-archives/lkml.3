Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936622Ab3DRUq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:46:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41936 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936581Ab3DRUq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:46:26 -0400
Message-ID: <51705B87.9000509@zytor.com>
Date: Thu, 18 Apr 2013 13:45:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Darren Hart <darren.hart@intel.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt@console-pimps.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf> <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf> <51704FA8.7060801@console-pimps.org> <1366315083.13667.19.camel@x230.lan> <51705366.8070001@intel.com> <517053EF.2030900@zytor.com> <517054EF.9070500@intel.com>
In-Reply-To: <517054EF.9070500@intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 01:17 PM, Darren Hart wrote:
> 
> Ah, well then I've misunderstood the nature of the problem a bit. Will
> have to spend some time understanding this better.
> 

Way, way too many people misunderstand HIGHMEM.

	-hpa

