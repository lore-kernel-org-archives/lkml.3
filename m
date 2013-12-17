Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3LQIFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:05:49 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:48369 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3LQIFs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 17 Dec 2013 03:05:48 -0500
Message-Id: <52B013E8020000780010E009@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 17 Dec 2013 08:05:44 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Tony Luck" <tony.luck@intel.com>
Cc: "Matt Fleming" <matt.fleming@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] don't select EFI from certain special ACPI drivers
References: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F31D8A4C2@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D8A4C2@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.12.13 at 00:04, "Luck, Tony" <tony.luck@intel.com> wrote:
>>  Adjust Kconfig and build logic so that the bad dependency gets avoided.
> 
> Has this been exposed to a randconfig test robot?  Moving cper.c has already
> dropped a few e-mails into my mailbox ... I'm now wary about the corner 
> cases.

No, it hasn't. But I explicitly checked the relevant EFI=n and EFI=y
cases.

Jan

