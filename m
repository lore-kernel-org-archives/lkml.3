Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3JYMtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:49:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53544 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3JYMtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:49:02 -0400
Message-ID: <526A6898.8030806@zytor.com>
Date: Fri, 25 Oct 2013 13:48:24 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        tianyu.lan@intel.com, Matthew Garrett <mjg@redhat.com>, x86@kernel.org,
        holt@sgi.com, davej@fedoraproject.org, lenb@kernel.org,
        rjw@rjwysocki.net, awilliam@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com> <20131025105352.GA5419@gmail.com> <20131025124402.GA7089@redhat.com>
In-Reply-To: <20131025124402.GA7089@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 01:44 PM, Dave Jones wrote:
> 
> I have a few machines at home that have the same problem.
> There does seem to be a number of vendor wide issues here. Pretty much
> every vaio and every Dell seems to need working around.
> 

The Dell problem I believe is understood... they are invoking the KBC as
their ACPI reboot port, and it is believed that that triggers an SMI
which invokes the BIOS, and the BIOS is broken if you behave like a
non-Windows system.

	-hpa

