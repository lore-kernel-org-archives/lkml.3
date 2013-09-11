Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3IKU0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:26:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46429 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3IKU0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:26:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, yinghai@kernel.org, bhelgaas@google.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] ACPI/Resource: Add address translation support
Date: Wed, 11 Sep 2013 22:37:33 +0200
Message-ID: <1471266.A5mlsVTEW9@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52307D9D.3070801@intel.com>
References: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com> <522D3002.5050304@intel.com> <52307D9D.3070801@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 11, 2013 10:26:37 AM Lan Tianyu wrote:
> On 09/08/2013 10:18 PM, Lan Tianyu wrote:
> > On 2013年09月07日 08:15, Rafael J. Wysocki wrote:
> >> On Friday, September 06, 2013 10:24:44 AM Lan Tianyu wrote:
> >>> According ACPI 5.0 spec Section 19.1.8
> >>> "For bridges, translate addresses across the bridge, this is the
> >>> offset that must be added to the address on the secondary side
> >>> to obtain the address on the primary side. Non-bridge devices
> >>> must list 0."
> >>
> >> Can you please have a look into the previous versions of the spec and double
> >> check that this change won't confuse systems that implement them?
> >>
> >
> > Hi Rafael:
> >           I check all versions. This part has existed and not been
> > changed since ACPI 1.0.
> >
> 
> Hi Rafael:
> 	Do you have other comments on this?

Well, why would I?  You're saying that you've verified it and that's OK.

Thanks,
Rafael

