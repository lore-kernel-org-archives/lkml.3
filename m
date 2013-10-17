Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JQKc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:32:26 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:38621 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3JQKcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:32:25 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-78-525fbcb7c0b3
Date: Thu, 17 Oct 2013 07:32:18 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-id: <20131017073218.11aae607@samsung.com>
In-reply-to: <3908561D78D1C84285E8C5FCA982C28F31D31C28@ORSMSX106.amr.corp.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com> <20131015170039.GF7908@pd.tnic>
 <525D7BCD.7080303@linux.vnet.ibm.com>
 <20131015214346.68718bcd.m.chehab@samsung.com>
 <20131016091640.GA13608@pd.tnic>
 <20131016073539.5a48f65e.m.chehab@samsung.com>
 <3908561D78D1C84285E8C5FCA982C28F31D31C28@ORSMSX106.amr.corp.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/hYN3te+KDDK6+MLJoO/GbzeLzhn9s
	Frfe2Vos39fPaHF51xw2i/stT9ktzhw6xGjx5sI9FgcOj++tfSwei/e8ZPKYdzLQ48GhzSwe
	7/ddZfP4vEkugC2KyyYlNSezLLVI3y6BK6NnyxvWgg72iuMPZ7M0MB5l7WLk5JAQMJG4/uAE
	lC0mceHeejYQW0hgCaPEhykRXYxcQHYPk8TNnj52kASLgKrEhBntLCA2m4CRxKvGFrBmEQE1
	iUuLHzCDNDAL3GSSOP34DiNIQljAS+JUyx0mEJtXwFCi5fY3MJtTIEzi4NUZrBAbzjFLnNra
	AtTNAXSGk8TWqb4Q9YISPybfA1vGLKAlsXlbEyuELS+xec1b5gmMArOQlM1CUjYLSdkCRuZV
	jKKlxckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFhX7yD8cUGq0OMAhyMSjy8M5bHBQmxJpYVV+Ye
	YpTgYFYS4d2yPT5IiDclsbIqtSg/vqg0J7X4ECMTB6dUA6PM1d7ds5t2suyv996zbO9mfUvn
	b/qshvPvVf93vyUgWeNiYb7osePrRwy/2OJepZpOPFz0gqE/qoTBt+TinRei30ymTN7mKhz4
	9NbE1jefhSIM1xyP5bB+aznn+KGNu/ZE58txXs5jWH84sC3mgSnjhHlWr2z7b89WPDvz+z6b
	i34nBDR5zHKUWIozEg21mIuKEwHAEXoxWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 20:35:32 +0000
"Luck, Tony" <tony.luck@intel.com> escreveu:

> > Are there any changes with regards to that, like some enforcement policy
> > for BIOS manufacturers to make it right?
> 
> I am using a cricket bat to beat BIOS teams that implement eMCA to make
> sure they get the labels in SMBIOS right. :-)

:)

> It's a non-trivial implementation effort to get all the decoding done for
> the eMCA log.  It's typically a simple string change to fix the SMBIOS
> table ... there has been some resistance - but so far I have been victorious.
> Wish me luck as I'm about to engage with another team.

Yes, the DMI changes are trivial. Let's hope that they'll do it right.

Yet, I think we should keep (at least for a while) a mechanism similar to
what EDAC does, allowing those names to be overridden by loading a different
table, where needed.

Regards,
Mauro
